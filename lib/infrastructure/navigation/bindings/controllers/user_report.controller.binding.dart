import 'package:get/get.dart';

import '../../../../presentation/user/report/controllers/user_report.controller.dart';

class UserReportControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserReportController>(
      () => UserReportController(),
    );
  }
}
