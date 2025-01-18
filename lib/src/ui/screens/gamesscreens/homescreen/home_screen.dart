import 'package:get/get.dart';
import 'package:igameapp/generated/locales.g.dart';
import 'package:igameapp/src/configs/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igameapp/src/data/models/BaseResponse.dart';
import 'package:igameapp/src/data/models/api_state.dart';
import 'package:igameapp/src/data/models/gamesmodels/game_model.dart';
import 'package:igameapp/src/ui/screens/gamesscreens/homescreen/home_controller.dart';
import 'package:igameapp/src/ui/widgets/appbars/app_bar_home.dart';
import 'package:igameapp/src/ui/widgets/common/getx_state_widget.dart';
import 'package:igameapp/src/ui/widgets/items/item_game.dart';
import 'package:igameapp/src/ui/widgets/sections/games_pagination_widget.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends GetWidget<HomeController> {
  static const String route = "/HomeScreen";

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBarHome(
          title: LocaleKeys.popular_games_right_now.tr,
        ),
        body: Container(
          margin: EdgeInsetsDirectional.only(
              start: Dimens.mainMargin, end: Dimens.mainMargin),
          child: RefreshIndicator(
            onRefresh: controller.onRefresh,
            color: Get.theme.colorScheme.secondary,
            child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: controller.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      height: 16.h,
                    ),
                    // Without Pagination
                    /*GetXStateWidget(
                      snapshotLiveData: controller.gamesListResponseLiveData,
                      loadingWidget: buildLoadingGamesWidget(),
                      contentWidget: (data) {
                        return buildGamesWidget(data?.list ?? []);
                      },
                      errorWidget: buildErrorConnectionWidget(),
                      onRetryClicked: () {
                        controller.getGames();
                      },
                    ),*/
                    handleErrorConnectionStateWidget(),
                    SizedBox(
                      height: 48.h,
                    ),
                  ],
                )),
          ),
        ),
        // bottomNavigationBar: buildUpdateButton(context),
      ),
    );
  }

  Widget buildGamesWidget(List<GameModel> list) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ItemGame(
            game: list[index],
            onClick: (game) {
              controller.goToGameDetailsScreen(game);
            },
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 10.h,
          );
        },
        itemCount: list.length ?? 0);
  }

  buildGamesPaginationWidget() {
    return GamesPaginationWidget(
      snapshot: controller.gamesListResponseLiveData,
      onRetryPressed: () {
        controller.getGames();
      },
      onPaginationRetryClick: () {
        controller.getNewPage();
      },
      paginationLiveData: controller.paginationLiveData,
      onReturnGame: (game) {
        controller.goToGameDetailsScreen(game);
      },
    );
  }

  Widget buildErrorConnectionWidget() {
    return Obx(() {
      return controller.localGames?.length == 0
          ? Center(
              child: Text("No Cashed Games"),
            )
          : buildGamesWidget(controller.localGames ?? []);
    });
  }

  Widget buildLoadingGamesWidget() {
    return Shimmer.fromColors(
      baseColor: Get.isDarkMode ? Colors.white12 : Colors.grey[300]!,
      highlightColor:
          Get.isDarkMode ? Colors.white12.withOpacity(0.5) : Colors.grey[100]!,
      child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ItemGameShimmer();
          },
          separatorBuilder: (context, index) {
            return Container(
              height: 10.h,
            );
          },
          itemCount: 4),
    );
  }

  handleErrorConnectionStateWidget() {
    return Obx(() {
      return controller.gamesListResponseLiveData.value.status == Status.ERROR
          ? buildErrorConnectionWidget()
          : buildGamesPaginationWidget();
    });
  }
}
