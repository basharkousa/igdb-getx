import 'package:get/get.dart';
import 'package:igameapp/src/ui/screens/gamesscreens/gamedetailsscreen/game_details_controller.dart';
import 'package:igameapp/src/ui/screens/gamesscreens/homescreen/home_controller.dart';
import 'package:igameapp/src/ui/screens/settingscreen/settings_controller.dart';
import 'package:igameapp/src/ui/screens/gamesscreens/savedgamesscreen/saved_games_controller.dart';
import '../../controllers/app_controller.dart';
import '../../data/repository.dart';
import 'modules/local_bindings.dart';
import 'modules/remote_bindings.dart';
import '../../ui/screens/getStartedScreens/splashScreen/splash_screen_controller.dart';

class AppBindings extends Bindings {
  // final Repository repository;

  // final GlobalAppBloc globalAppBloc;

  AppBindings();

  @override
  void dependencies() {

    LocalBindings().dependencies();

    RemoteBindings().dependencies();

    Get.lazyPut<Repository>(() {
      return Repository(Get.find(), Get.find());
    }, fenix: true);

    Get.put(AppController(Get.find<Repository>()), permanent: true);

    Get.create<SplashScreenController>(() {
      return SplashScreenController(Get.find<Repository>());
    });

    /*---------------------------- App CONTROLLERS -------------------------------*/

    Get.lazyPut<HomeController>(() {
      return HomeController();
    }, fenix: true);

    Get.create<GameDetailsController>(() {
      return GameDetailsController();
    });

    Get.lazyPut<SavedGamesController>(() {
      return SavedGamesController();
    }, fenix: true);

    Get.lazyPut<SettingsController>(() {
      return SettingsController();
    }, fenix: true);

  }
}
