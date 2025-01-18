import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:igameapp/src/data/local/datasources/floor/entity/game_entity.dart';
import 'package:igameapp/src/data/models/BaseResponse.dart';
import 'package:igameapp/src/data/models/api_state.dart';
import 'package:igameapp/src/data/models/gamesmodels/game_model.dart';
import 'package:igameapp/src/data/remote/exceptions/dio_error_util.dart';
import 'package:igameapp/src/data/repository.dart';
import 'package:igameapp/src/ui/screens/gamesscreens/gamedetailsscreen/game_details_screen.dart';

// with SingleGetTickerProviderMixin
class HomeController extends GetxController{

  final Repository repository = Get.find();

  HomeController();

  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int limit = 8;
  int offset = 0;
  BaseResponse<GameModel> gamesList = BaseResponse<GameModel>();
  var gamesListResponseLiveData = ApiState<BaseResponse<GameModel>>.loading().obs;
  var paginationLiveData =
      ApiState<BaseResponse<GameModel>>.completed(null).obs;
  getGames() async {
    offset = 0;
    gamesListResponseLiveData.value = ApiState.loading();
    try {
      BaseResponse<GameModel> gamesListResponse = await repository.getGames(
          {
            "limit":limit,
            "offset":offset,
          }
      );
      gamesList = gamesListResponse;
      gamesListResponseLiveData.value = ApiState.completed(gamesList);
      repository.removeGames();
      List<GameEntity>? listGameEntities = [];
      for(var game in  gamesListResponseLiveData.value.data?.list??[]){
        listGameEntities.add(GameEntity.from(game));
        repository.addGames(listGameEntities);
      }
    } on DioException catch (error, stacktrace) {
      await getLocalGamesList();
      gamesListResponseLiveData.value =
          ApiState.error(DioErrorUtil.handleError(error));
      print('DioException: $stacktrace');
    } catch (error, stacktrace) {
      await getLocalGamesList();
      gamesListResponseLiveData.value = ApiState.error(error.toString());
      print('Error: $stacktrace');
    }
  }
  getNewPage() async {
    print("getNewPage");
    if (!isLoading) {
      offset = offset + limit;
      paginationLiveData.value =
      ApiState<BaseResponse<GameModel>>.loading();
      isLoading = !isLoading;
      try {
        BaseResponse<GameModel> auctionsListResponse = await repository.getGames(
            {
              "limit":limit,
              "offset":offset,
            });
        gamesList.list!.addAll(auctionsListResponse.list!);
        gamesListResponseLiveData.value =
        ApiState<BaseResponse<GameModel>>.completed(gamesList);
        paginationLiveData.value =
        ApiState<BaseResponse<GameModel>>.completed(gamesList);
        isLoading = !isLoading;
      } on DioException catch (error, stacktrace) {
        paginationLiveData.value = ApiState<BaseResponse<GameModel>>.error(
            DioErrorUtil.handleError(error));
        offset = offset - limit;
        isLoading = !isLoading;
        print(stacktrace);
      }catch (error, stacktrace){
        paginationLiveData.value = ApiState<BaseResponse<GameModel>>.error(
            error.toString());
        offset = offset - limit;
        isLoading = !isLoading;
        print(stacktrace);
      }
    }
  }
  

  RxList<GameModel>? localGames = <GameModel>[].obs;
  getLocalGamesList() async{
    localGames?.clear();
    var localGamesEntities = await repository.getLocalGamesList();
    localGamesEntities?.forEach((gameEntity){
      localGames?.add(gameEntity.toGameModel());
    });
    print("taskHistoryListLength ${localGamesEntities?.length}");
  }

  //Todo without pagination
  /*var projectsResponseLiveData = ApiState<BaseResponse<GameModel>>.loading().obs;
  getGames() async {
    projectsResponseLiveData.value = ApiState.loading();
    try {
      var map = {"":""};
      BaseResponse<GameModel> projectsResponse = await repository.getGames(map);
      projectsResponseLiveData.value = ApiState.completed(projectsResponse);
      repository.removeGames();
      List<GameEntity>? listGameEntities = [];
      for(var game in  projectsResponseLiveData.value.data?.list??[]){
        listGameEntities.add(GameEntity.from(game));
        repository.addGames(listGameEntities);
      }
    } on DioException catch (error, stacktrace){
      await getLocalGamesList();
      projectsResponseLiveData.value =
          ApiState.error(DioErrorUtil.handleError(error));
      print('DioException$error $stacktrace');
    } catch (error, stacktrace) {
      projectsResponseLiveData.value = ApiState.error(error.toString());
      print('OtherException:$error $stacktrace');
    }
  }*/

  @override
  void onInit() {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        print("End scrolling");
        getNewPage();
      }
    });
    getGames();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onRefresh() async{
    getGames();
    getLocalGamesList();
  }

  void goToGameDetailsScreen(GameModel project) {
    Get.toNamed(GameDetailsScreen.route,arguments: project);
  }
}