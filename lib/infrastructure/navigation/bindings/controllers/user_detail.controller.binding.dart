import 'package:get/get.dart';

import '../../../../presentation/user/detail/controllers/user_detail.controller.dart';

class UserDetailControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserDetailController>(
      () => UserDetailController(),
    );
  }
}
