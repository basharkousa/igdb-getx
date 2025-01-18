import 'package:get/get.dart';
import 'package:igameapp/generated/locales.g.dart';
import 'package:igameapp/src/configs/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igameapp/src/data/models/gamesmodels/game_model.dart';
import 'package:igameapp/src/ui/screens/gamesscreens/savedgamesscreen/saved_games_controller.dart';
import 'package:igameapp/src/ui/widgets/appbars/app_bar_default.dart';
import 'package:igameapp/src/ui/widgets/buttons/button_default.dart';
import 'package:igameapp/src/ui/widgets/common/extentions.dart';
import 'package:igameapp/src/ui/widgets/items/item_game.dart';
import 'package:shimmer/shimmer.dart';

class SavedGamesScreen extends GetWidget<SavedGamesController> {
  static const String route = "/SavedGamesScreen";

  SavedGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBarDefault(
          title: LocaleKeys.saved_games.tr,
        ),
        body: Column(
          children: [
            Expanded(
                child: Container(
              margin: EdgeInsetsDirectional.only(
                  start: Dimens.mainMargin, end: Dimens.mainMargin),
              child: RefreshIndicator(
                onRefresh: controller.onRefresh,
                color: Get.theme.colorScheme.secondary,
                child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SizedBox(
                          height: 16.h,
                        ),
                        buildLocalGamesWidget(),
                        SizedBox(
                          height: 48.h,
                        ),
                      ],
                    )),
              ),
            )),
          ],
        ),
        bottomNavigationBar: buildButtonClearHistory(),
      ),
    );
  }


  Widget buildLocalGamesWidget() {
    return Obx((){
      return controller.localGames?.length == 0
          ? Center(
        child: Text("No Cashed Games"),
      )
          : buildGamesWidget(controller.localGames ?? []);
    });
  }

  Widget buildGamesWidget(List<GameModel> list) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ItemGame(
            game: list[index],
            onClick: (game) {
              // controller.goToGameDetailsScreen(game);
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


  buildButtonClearHistory() {
    return ButtonDefault(
      title: LocaleKeys.remove_games.tr,
    ).onClickBounce((){
      controller.clearTaskHistory();
    });
  }


}
