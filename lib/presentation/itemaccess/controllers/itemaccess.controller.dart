import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/general.dart';

class ItemaccessController extends GetxController {
  final count = 0.obs;
  TextEditingController? freeRctlr;
  TextEditingController? paidRctlr;
  TextEditingController? freeSwipectlr;
  TextEditingController? paidSwipectlr;
  Map<String, dynamic> data = {};
  Map items = {};
  RxBool edit = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    data = {};
    freeRctlr = TextEditingController();
    paidRctlr = TextEditingController();
    freeSwipectlr = TextEditingController();
    paidSwipectlr = TextEditingController();
    getAccessItems();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    freeRctlr?.dispose();
    paidRctlr?.dispose();
    freeSwipectlr?.dispose();
    paidSwipectlr?.dispose();
  }

  getAccessItems() async {
    isLoading.value = true;
    print(items.length);
    var doc = await queryCollectionDB("Item_access").get();
    if (doc.docs.isNotEmpty) {
      items = doc.docs.first.data();
      if (kDebugMode) {
        print(doc.docs.first.data());
      }
      freeRctlr?.text = items['free_radius'];
      paidRctlr?.text = items['paid_radius'];
      freeSwipectlr?.text = items['free_swipes'];
    } else {
      freeRctlr?.text = '0';
      paidRctlr?.text = "0";
      freeSwipectlr?.text = "0";
    }
    isLoading.value = false;
  }
}
