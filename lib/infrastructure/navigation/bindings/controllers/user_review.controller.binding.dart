import 'package:get/get.dart';

import '../../../../presentation/user/review/controllers/user_review.controller.dart';

class UserReviewControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserReviewController>(
      () => UserReviewController(),
    );
  }
}
