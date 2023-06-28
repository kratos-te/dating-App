import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:r_firedart/generated/google/protobuf/timestamp.pb.dart';
// import 'package:r_firedart/r_firedart.dart';
import 'package:unjabbed_admin/domain/core/model/PackageModel.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/general.dart';
import 'package:unjabbed_admin/presentation/package/view/create_package.dart';

import '../../../infrastructure/dal/util/Global.dart';

class PackageController extends GetxController {
  RxList<PackageModel> listPackages = RxList();
  Map<String, dynamic> data = {};
  TextEditingController? idctlr;
  TextEditingController? titlectlr;
  TextEditingController? descctlr;
  PackageModel? selectedPackage;
  RxBool active = false.obs;
  bool edit = false;

  @override
  void onInit() {
    initAll();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  initAll() {
    getPackages();
    idctlr = TextEditingController();
    titlectlr = TextEditingController();
    descctlr = TextEditingController();
  }

  initAddOrCreatePackage(PackageModel? package) {
    data = {};
    edit = false;
    active.value = false;
    selectedPackage = package;
    idctlr?.text = selectedPackage?.id ?? "";
    titlectlr?.text = selectedPackage?.title ?? "";
    descctlr?.text = selectedPackage?.description ?? "";
    data['status'] = false;
    if (selectedPackage != null) {
      active.value = selectedPackage?.status ?? false;
      edit = true;
      data = selectedPackage?.toJson() ?? {};
    }
    if (!edit && listPackages.length > 6) {
      Global().showInfoDialog(
        "You have created already max number of packages",
      );
      return;
    }
    Get.to(() => CreatePackageWidget());
  }

  getPackages() async {
    var doc = await queryCollectionDB("Packages")
        .orderBy('timestamp', descending: false)
        .get();
    listPackages.clear();
    for (var item in doc.docs) {
      Map<String, dynamic> data = item.data();
      listPackages.add(PackageModel.fromJson(data));
    }
  }

  editPackage() async {
    if (data.isEmpty ||
        data['id'].isEmpty ||
        data['description'].isEmpty ||
        data['title'].isEmpty) {
      Global().showInfoDialog("Please fill the requirement first");
      return;
    }
    var cek = await queryCollectionDB("Packages").doc(data['id']).get();
    if (!edit && cek.exists) {
      Global().showInfoDialog("ID already used");
      return;
    }
    data['timestamp'] = DateTime.now();
    await queryCollectionDB("Packages").doc(data['id']).set(data, SetOptions(merge: true));
    await getPackages();
    Get.back();
  }
}
