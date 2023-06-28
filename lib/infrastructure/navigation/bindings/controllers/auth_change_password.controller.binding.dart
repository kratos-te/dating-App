import 'package:get/get.dart';

import '../../../../presentation/auth/change_password/controllers/auth_change_password.controller.dart';

class AuthChangePasswordControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthChangePasswordController>(
      () => AuthChangePasswordController(),
    );
  }
}
