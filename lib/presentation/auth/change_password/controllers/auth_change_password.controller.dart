import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/core/interfaces/widget/alert.dart';
import '../../../../infrastructure/dal/util/Global.dart';
import '../../../../infrastructure/dal/util/general.dart';

class AuthChangePasswordController extends GetxController {
  TextEditingController? newId;
  TextEditingController? newPasswd;
  RxBool isLoading = false.obs;
  RxBool showPass = false.obs;

  @override
  void onInit() {
    super.onInit();
    newId = new TextEditingController();
    newPasswd = new TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    newId?.dispose();
    newPasswd?.dispose();
  }

  updateAdminAccount() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return BeautifulAlertDialog(
          text: "Do you want to change the id/password ?",
          onYesTap: () async {
            await queryCollectionDB("Admin")
                .doc("id_password")
                .set({"id": newId?.text, "password": newPasswd?.text}, SetOptions(merge: true))
                .whenComplete(
                  () => Global().showInfoDialog("changed successfully!!"),
                )
                .catchError(
                  (onError) => Global().showInfoDialog(onError),
                );
            Navigator.pop(context);
          },
          onNoTap: () => Navigator.pop(context),
        );
      },
    );
  }
}
