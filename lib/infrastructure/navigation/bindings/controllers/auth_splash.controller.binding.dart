import 'package:get/get.dart';

import '../../../../presentation/auth/splash/controllers/auth_splash.controller.dart';

class AuthSplashControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthSplashController>(
      () => AuthSplashController(),
    );
  }
}
