import 'package:get/get.dart';
import 'package:igameapp/src/data/models/gamesmodels/game_model.dart';
import 'package:igameapp/src/data/repository.dart';

// with SingleGetTickerProviderMixin
class SavedGamesController extends GetxController{

  final Repository repository = Get.find();
  SavedGamesController();

  RxList<GameModel>? localGames = <GameModel>[].obs;
  getLocalGamesList() async{
    localGames?.clear();
    var localGamesEntities = await repository.getLocalGamesList();
    localGamesEntities?.forEach((gameEntity){
      localGames?.add(gameEntity.toGameModel());
    });
    print("ListLength ${localGamesEntities?.length}");
  }

  clearTaskHistory() async{
    repository.removeGames();
    localGames?.clear();
  }

  @override
  void onInit() {
    getLocalGamesList();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onRefresh() async{
    getLocalGamesList();
  }

}