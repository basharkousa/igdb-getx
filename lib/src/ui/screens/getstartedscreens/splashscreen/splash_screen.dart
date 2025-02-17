import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../../../generated/locales.g.dart';
import '../splashScreen/splash_screen_controller.dart';
import '../../../widgets/common/getx_state_widget.dart';
import '../../../widgets/sections/app_logo_widget.dart';
import '../../../widgets/sections/background_theme_widget.dart';

class SplashScreenPage extends StatelessWidget {
  static const String route = "/";

  final SplashScreenController controller = Get.find();

  SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          // backgroundColor: Colors.black,
          body: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              const BackGroundThemeWidget(),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   AppLogoSection(),
                ],
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 34.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GetXStateWidget(
                        snapshotLiveData: controller.loginResponseLiveData,
                        loadingWidget: SpinKitCircle(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          // color: Colors.red,
                          size: 32.h,
                        ),
                      ),
                      SizedBox(
                        height: 21.h,
                      ),
                      Text(
                        LocaleKeys.explore_your_interesting_games.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          // fontFamily: FontFamily.montserrat,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}