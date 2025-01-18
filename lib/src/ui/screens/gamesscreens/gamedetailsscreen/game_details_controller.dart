import 'package:get/get.dart';
import 'package:igameapp/src/data/models/gamesmodels/game_model.dart';
import 'package:igameapp/src/data/repository.dart';

// with SingleGetTickerProviderMixin
class GameDetailsController extends GetxController {
  final Repository repository = Get.find();
  GameModel game = Get.arguments;

  GameDetailsController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onRefresh() async {}
}

