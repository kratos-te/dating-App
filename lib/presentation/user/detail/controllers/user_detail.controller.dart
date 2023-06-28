import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/general.dart';
import 'package:unjabbed_admin/presentation/user/detail/vinculo_model.dart';
import '../../../../domain/core/model/user_model.dart';
import '../../../../infrastructure/dal/services/fcm_service.dart';
import '../../../../infrastructure/dal/util/Global.dart';

class UserDetailController extends GetxController {
  RxBool isLoadingBtn = false.obs;
  RxBool isLoading = false.obs;
  TextEditingController? title;
  TextEditingController? content;
  Vinculo? titleText;
  Vinculo? bodyText;
  Rxn<UserModel> selectedUser = Rxn();

  @override
  void onInit() {
    super.onInit();
    title = TextEditingController();
    content = TextEditingController();
    initDetailUser();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    title?.dispose();
    content?.dispose();
  }

  initDetailUser() async {
    print("Masuk sini");
    isLoading.value = true;
    var doc =
        await queryCollectionDB("Users").doc(Get.parameters['idUser']).get();
    selectedUser.value = UserModel.fromJson(doc.data()!);
    await Future.delayed(Duration(seconds: 1));
    isLoading.value = false;
    print(isLoading.value);
  }

  sendtoUsers(UserModel tempUser) async {
    if ((title?.text ?? '').isEmpty) {
      Get.snackbar("Information", "Please field title first");
      return;
    }
    isLoading.value = true;
    try {
      var data = {"title": (title?.text ?? ""), "body": (content?.text ?? "")};
      String toParams = "/topics/" + (tempUser.id);
      await FCMService().sendFCM(data: data, to: toParams);
      Global().showInfoDialog("Success Send Broadcast");
    } catch (e) {
      if (kDebugMode) {
        print("Error : " + e.toString());
      }
      Global().showInfoDialog(e.toString());
    }
    isLoading.value = false;
  }
}
