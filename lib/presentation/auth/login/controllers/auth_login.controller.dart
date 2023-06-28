import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/general.dart';

class AuthLoginController extends GetxController {
  late TextEditingController username;
  late TextEditingController password;
  RxBool isLoading = false.obs;
  RxBool showPass = false.obs;

  @override
  void onInit() {
    super.onInit();
    initLogin();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    username.dispose();
    password.dispose();
  }

  initLogin() {
    username = TextEditingController();
    password = TextEditingController();
    if (kDebugMode) {
      username.text = "unjabbed";
      password.text = "n%0AIDKM\$36ZLj";
    }
    setIdPass();
  }

  Future setIdPass() async {
    var doc = await queryCollectionDB("Admin").doc("id_password").get();
    if (!doc.exists) {
      await queryCollectionDB("Admin").doc("id_password").set(
        {"id": "admin", "password": "jabless2022"},
        SetOptions(merge: true),
      );
    }
  }

  Future<bool> login(String id, String paswd) async {
    isLoading.value = true;
    var doc = await queryCollectionDB("Admin").doc("id_password").get();
    Map authData = doc.data()!;
    if (authData['id'] == id && authData['password'] == paswd) {
      return true;
    }
    return false;
  }
}
