import 'package:get/get.dart';
import 'package:igameapp/src/ui/screens/gamesscreens/homescreen/home_screen.dart';
import '../../../../data/models/api_state.dart';
import '../../../../data/repository.dart';

class SplashScreenController extends GetxController {
  final Repository repository;

  var loginResponseLiveData = ApiState<void>.loading().obs;

  SplashScreenController(this.repository);

  @override
  void onInit() {
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    Future.delayed(const Duration(milliseconds: 3100), () {
      goToHomeScreen();
    });
    super.onInit();
  }

  Future<void> goToHomeScreen() async {
    Get.offNamed(HomeScreen.route);
  }

}
