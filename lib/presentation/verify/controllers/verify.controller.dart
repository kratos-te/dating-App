import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unjabbed_admin/domain/core/model/VerifyModel.dart';
import 'package:unjabbed_admin/infrastructure/dal/services/fcm_service.dart';
import 'package:unjabbed_admin/presentation/user/detail/vinculo_model.dart';

import '../../../infrastructure/dal/util/Global.dart';
import '../../../infrastructure/dal/util/general.dart';
import '../../user/detail/custom_dropdown_widget.dart';

class VerifyController extends GetxController {
  TextEditingController? searchctrlr;
  RxBool isLoading = false.obs;
  RxList<VerifyModel> listVerifyAll = RxList();
  RxList<VerifyModel> listVerifySearchAll = RxList();
  RxList<VerifyModel> listVerify = RxList();
  RxInt documentLimit = 25.obs;
  RxInt totalDoc = 0.obs;
  RxInt totalDocSearch = 0.obs;
  RxBool isSearch = false.obs;
  RxBool sort = false.obs;
  String tempQuery = "";
  RxInt start = 0.obs;
  RxInt end = 0.obs;
  Vinculo? titleText;

  @override
  void onInit() {
    super.onInit();
    searchctrlr = TextEditingController();
    initAll();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    searchctrlr?.dispose();
  }

  initAll() async {
    var listDoc = await queryCollectionDB("Verify")
        .orderBy("date_updated", descending: true)
        .where("verified", whereIn: [0, 1]).get();
    if (listDoc.docs.isNotEmpty) {
      totalDoc.value = listDoc.docs.length;
      for (var doc in listDoc.docs) {
        print(doc.id);
        listVerifyAll.add(VerifyModel.fromJson(doc.data()!));
      }
      initVerify(addUser: true, firstInit: true);
    }
  }

  initVerify({required bool addUser, bool firstInit = false}) {
    if (listVerifyAll.isEmpty) {
      return;
    }
    if (addUser && end.value == totalDoc.value) {
      return;
    }
    if (!addUser && start.value == 0) {
      return;
    }
    if (firstInit) {
      start.value = 0;
      end.value = 0;
    }
    if (addUser) {
      start.value = end.value;
      if ((end.value + documentLimit.value) >= (totalDoc.value - 1)) {
        end.value = totalDoc.value;
      } else {
        end.value = end.value + documentLimit.value;
      }
    } else {
      end.value = start.value;
      if ((start.value - documentLimit.value) < 0) {
        start.value = 0;
      } else {
        start.value = start.value - documentLimit.value;
      }
    }
    listVerify.assignAll(
      Global()
          .filterPagination(start.value, end.value, listVerifyAll)
          .toList()
          .map((e) => e as VerifyModel),
    );
  }

  searchFirstVerify(String query) {
    // if (tempQuery == query) {
    //   return;
    // }
    if (query.trim().length > 0) {
      tempQuery = query;
      getCountSearch(query);
      if (listVerifySearchAll.isEmpty) {
        return;
      }
      end.value = 0;
      start.value = end.value;
      if ((end.value + documentLimit.value) >= (totalDocSearch.value - 1)) {
        end.value = totalDocSearch.value;
      } else {
        end.value = end.value + documentLimit.value;
      }
      listVerify.assignAll(
        Global()
            .filterPagination(start.value, end.value, listVerifySearchAll)
            .toList()
            .map((e) => e as VerifyModel),
      );
      isSearch.value = true;
      return;
    }
    isSearch.value = false;
    initVerify(addUser: true, firstInit: true);
  }

  getCountSearch(String query) {
    listVerifySearchAll.value = listVerifyAll
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    totalDocSearch.value = listVerifySearchAll.length;
  }

  addVerifySearch(String query, bool addUser) {
    if (listVerifySearchAll.isEmpty) {
      return;
    }
    if (addUser && end.value == totalDocSearch.value) {
      return;
    }
    if (!addUser && start.value == 0) {
      return;
    }
    if (addUser) {
      start.value = end.value;
      if ((end.value + documentLimit.value) >= (totalDocSearch.value - 1)) {
        end.value = totalDocSearch.value;
      } else {
        end.value = end.value + documentLimit.value;
      }
    } else {
      end.value = start.value;
      if ((start.value - documentLimit.value) < 0) {
        start.value = 0;
      } else {
        start.value = start.value - documentLimit.value;
      }
    }
    listVerify.assignAll(
      Global()
          .filterPagination(start.value, end.value, listVerifySearchAll)
          .toList()
          .map((e) => e as VerifyModel),
    );

    ;
  }

  acceptDialog(String idUser) async {
    TextEditingController reason = TextEditingController();
    ArtDialogResponse? response = await ArtSweetAlert.show(
      barrierDismissible: false,
      context: Get.context!,
      artDialogArgs: ArtDialogArgs(
        // showCancelBtn: true,
        denyButtonText: "No",
        title: "Are you sure that you would like to approve this user?",
        confirmButtonText: "Yes",
      ),
    );

    if (response == null) {
      return;
    }

    if (response.isTapConfirmButton) {
      await updateStatusVerifyUser(3, idUser, reason.text);
      ArtSweetAlert.show(
        context: Get.context!,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.success,
          title: "You've Accept user verification",
        ),
      );
      return;
    }
  }

  updateStatusVerifyUser(int status, String idUser, String reason) async {
    Map<String, dynamic> updateObject = {
      "verified": status,
      "reason_verified": reason,
      "date_updated": DateTime.now().toIso8601String(),
    };
    await queryCollectionDB("Verify").doc(idUser).set(updateObject, SetOptions(merge: true));
    await queryCollectionDB("Users").doc(idUser).set(
      {"verified": status, "reason_verified": reason},
      SetOptions(merge: true)
    );
    if (status == 2) {
      sendNotifFcm(
        idUser: idUser,
        msg: reason,
        title: "Verification Rejected",
      );
    }
    if (status == 3) {
      sendNotifFcm(
        idUser: idUser,
        msg: "Congratulations! You have been verified. Your profile should now display a green circle with a tick signifying your verification status.",
        title: "Verification Approve",
      );
    }
    listVerify.clear();
    initAll();
  }

  sendNotifFcm(
      {required String idUser,
      required String msg,
      required String title}) async {
    // UserModel userFCM = Get.find<TabsController>().getUserSelected(idUser);
    if (kDebugMode) {
      print("Send FCM");
    }
    String toParams = "/topics/" + idUser;
    var data = {"title": title, "body": msg};
    var response = await FCMService().sendFCM(data: data, to: toParams);
    // print(response);
    if (response) {
      print("Success Send FCM");
    } else {
      print(response);
    }
  }

  rejectDialog(String idUser) async {
    TextEditingController reason = TextEditingController();
    ArtDialogResponse? response = await ArtSweetAlert.show(
      barrierDismissible: false,
      context: Get.context!,
      artDialogArgs: ArtDialogArgs(
        // showCancelBtn: true,
        denyButtonText: "Cancel",
        title: "Are you sure that you would like to reject this user?", 
        confirmButtonText: "Submit",
        customColumns: [
          Container(
            width: 300,
  
            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(5),
            //     border: Border.all(color: Colors.red)),
            child: CustomDropDownWidget(
            withSearch: true,
            valueVinculo: true,
            title: 'Reason',
            maxLines: null,
            value: titleText,
            onChange: (Vinculo value){
              titleText=value;
              reason.text=value.value;
              // controller.content?.text=value.value;
              // controller.update();
            },
            textEditingController: reason,
            lista: vinculoList,
          ) 
          // TextField(
          //     keyboardType: TextInputType.multiline,
          //     maxLines: null,
          //     decoration: InputDecoration(
          //       border: InputBorder.none,
          //       hintText: "Reason",
          //       // labelText: "First Name",
          //     ),
          //     controller: reason,
          //   ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );

    if (response == null) {
      return;
    }

    if (response.isTapConfirmButton) {
      await updateStatusVerifyUser(2, idUser, reason.text);
      titleText=null;
      ArtSweetAlert.show(
          context: Get.context!,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.info,
              title: "You've Reject user verification"));
      return;
    }
  }
}
