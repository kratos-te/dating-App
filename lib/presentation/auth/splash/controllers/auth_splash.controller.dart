import 'package:get/get.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/general.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/session.dart';
import 'package:unjabbed_admin/infrastructure/navigation/routes.dart';

class AuthSplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initSplashScreen();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  initSplashScreen() async {
    await Future.delayed(Duration(seconds: 2));
    bool checkAuth = Session().getAuth();
    if (checkAuth) {
      // await globalController.initAfterLogin();
      Get.toNamed(Routes.USER);
      return;
    }
    Get.toNamed(Routes.AUTH_LOGIN);
  }
}
