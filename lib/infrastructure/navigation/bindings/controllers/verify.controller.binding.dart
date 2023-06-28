import 'package:get/get.dart';

import '../../../../presentation/verify/controllers/verify.controller.dart';

class VerifyControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyController>(
      () => VerifyController(),
    );
  }
}
