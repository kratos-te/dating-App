import 'package:get/get.dart';

import '../../../../presentation/package/controllers/package.controller.dart';

class PackageControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PackageController>(
      () => PackageController(),
    );
  }
}
