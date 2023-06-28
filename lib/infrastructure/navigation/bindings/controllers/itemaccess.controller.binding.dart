import 'package:get/get.dart';

import '../../../../presentation/itemaccess/controllers/itemaccess.controller.dart';

class ItemaccessControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ItemaccessController>(
      () => ItemaccessController(),
    );
  }
}
