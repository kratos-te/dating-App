import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unjabbed_admin/domain/core/model/user_model.dart';
import '../../../../domain/core/model/ReviewModel.dart';
import '../../../../infrastructure/dal/services/fcm_service.dart';
import '../../../../infrastructure/dal/util/Global.dart';
import '../../../../infrastructure/dal/util/general.dart';
import '../../detail/custom_dropdown_widget.dart';
import '../../detail/vinculo_model.dart';

class UserReviewController extends GetxController {
  TextEditingController? searchctrlr;
  RxBool isLoading = false.obs;
  RxList<ReviewModel> listReviewAll = RxList();
  RxList<ReviewModel> listReviewSearch = RxList();
  RxList<ReviewModel> listReview = RxList();
  RxInt documentLimit = 25.obs;
  RxInt totalDoc = 0.obs;
  RxInt totalDocSearch = 0.obs;
  RxBool isSearch = false.obs;
  RxBool sort = false.obs;
  String tempQuery = "";
  RxInt start = 0.obs;
  RxInt end = 0.obs;
  Vinculo? valueTitle;

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
    await getAllReview();
    initReview(add: true, firstInit: true);
    print("Jumlah User : " + listReviewAll.length.toString());
  }

  getAllReview() async {
    listReviewAll.value = [];
    var listDoc = await queryCollectionDB("Review")
        .orderBy("created_at", descending: true)
        .get();
    if (listDoc.docs.isNotEmpty) {
      totalDoc.value = listDoc.docs.length;
      for (var doc in listDoc.docs) {
        var suspendModel = ReviewModel.fromJson(doc.data()!);
        suspendModel.status?.value = suspendModel.getStatus();
        suspendModel.reason?.value = suspendModel.getReason();
        listReviewAll.add(suspendModel);
      }
    }
  }

  initReview({required bool add, bool firstInit = false}) {
    if (listReviewAll.isEmpty) {
      return;
    }
    if (add && end.value == totalDoc.value) {
      return;
    }
    if (!add && start.value == 0) {
      return;
    }
    if (firstInit) {
      start.value = 0;
      end.value = 0;
    }
    if (add) {
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

    listReview.assignAll(
      Global()
          .filterPagination(start.value, end.value, listReviewAll)
          .toList()
          .map((e) => e as ReviewModel),
    );
  }

  searchFirstVerify(String query) {
    // if (tempQuery == query) {
    //   return;
    // }
    if (query.trim().length > 0) {
      tempQuery = query;
      getCountSearch(query);
      if (listReviewSearch.isEmpty) {
        return;
      }
      end.value = 0;
      start.value = end.value;
      if ((end.value + documentLimit.value) >= (totalDocSearch.value - 1)) {
        end.value = totalDocSearch.value;
      } else {
        end.value = end.value + documentLimit.value;
      }
      listReview.assignAll(
        Global()
            .filterPagination(start.value, end.value, listReviewSearch)
            .toList()
            .map((e) => e as ReviewModel),
      );
      isSearch.value = true;
      return;
    }
    isSearch.value = false;
    initReview(add: true, firstInit: true);
  }

  getCountSearch(String query) {
    listReviewSearch.value = listReviewAll
        .where((element) =>
            element.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    totalDocSearch.value = listReviewSearch.length;
  }

  addReviewSearch(String query, bool addUser) {
    if (listReviewSearch.isEmpty) {
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

    listReview.assignAll(
      Global()
          .filterPagination(start.value, end.value, listReviewSearch)
          .toList()
          .map((e) => e as ReviewModel),
    );
  }

  updateSuspendWidget(String status, ReviewModel suspendModel) async {
    TextEditingController reason = TextEditingController();
    ArtDialogResponse? response = await ArtSweetAlert.show(
      barrierDismissible: true,
      context: Get.context!,
      artDialogArgs: ArtDialogArgs(
        denyButtonText: "No",
        title:
            "Are you sure that you would ${status.capitalizeFirst} this user?",
        confirmButtonText: "Yes",
        customColumns: [
          Container(
            width: 300,
            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(5),
            //     border: Border.all(color: Colors.red)),
            child:CustomDropDownWidget(
                        withSearch: true,
                        valueVinculo: true,
                        title: 'Reason',
                        maxLines: null,
                        value: valueTitle,
                        onChange: (Vinculo value){
                          valueTitle=value;
                          // content?.text=value.value;
                          // update();
                        },
                        textEditingController: reason,
                        lista: vinculoList,
                      ), 
            //           TextField(
            //   decoration: InputDecoration(
            //     border: InputBorder.none,
            //     labelText: "Reason",
            //   ),
            //   controller: reason,
            // ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );

    if (response != null && response.isTapConfirmButton) {
      var cek =
          await queryCollectionDB("Users").doc(suspendModel.idUser ?? "").get();
      if (!cek.exists) {
        Global().showInfoDialog("User not exist");
        return;
      }
      var query = cek;
      UserModel userModel = UserModel.fromJson(query.data()!);
      if (userModel.imageUrl[0].runtimeType == String) {
        userModel.imageUrl[0] = suspendModel.listImage?.first?.imageUrl;
      } else {
        userModel.imageUrl[0]['url'] = suspendModel.listImage?.first?.imageUrl;
      }
      await updateReview(status, suspendModel, reason.text);
      ArtSweetAlert.show(
        context: Get.context!,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.success,
          title: "You've ${status.capitalizeFirst ?? ""} user",
        ),
      );
    }
  }

  updateReviewWidget(String status, ReviewModel suspendModel) async {
    TextEditingController reason = TextEditingController();
    ArtDialogResponse? response = await ArtSweetAlert.show(
      barrierDismissible: true,
      context: Get.context!,
      artDialogArgs: ArtDialogArgs(
        showCancelBtn: true,
        cancelButtonText: "Cancel",
        denyButtonText: "Suspend",
        title: "Are you sure that you would Unsuspend this user?",
        confirmButtonText: "Unsuspend",
        customColumns: [
          Container(
            width: 300,
            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.red)),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: "Reason",
              ),
              controller: reason,
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );

    if (response != null && response.isTapConfirmButton) {
      var cek =
          await queryCollectionDB("Users").doc(suspendModel.idUser ?? "").get();
      if (!cek.exists) {
        Global().showInfoDialog("User not exist");
        return;
      }
      var query = cek;
      UserModel userModel = UserModel.fromJson(query.data()!);
      if (userModel.imageUrl[0].runtimeType == String) {
        userModel.imageUrl[0] = suspendModel.listImage?.first?.imageUrl;
      } else {
        userModel.imageUrl[0]['url'] = suspendModel.listImage?.first?.imageUrl;
      }
      await updateReview("unsuspend", suspendModel, reason.text);
      await queryCollectionDB("Users").doc(suspendModel.idUser ?? "").set(
        {"Pictures": userModel.imageUrl},
        SetOptions(merge: true),
      );
      ArtSweetAlert.show(
        context: Get.context!,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.success,
          title: "You've Unsuspend user",
        ),
      );
    }
    if (response != null && response.isTapDenyButton) {
      await updateReview("suspend", suspendModel, reason.text);

      ArtSweetAlert.show(
        context: Get.context!,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.success,
          title: "You've Suspend user",
        ),
      );
    }
  }

  updateReview(String status, ReviewModel suspendModel, String reason) async {
    suspendModel.listImage?.last?.status = status;
    suspendModel.listImage?.last?.reason = reason;
    suspendModel.listImage?.last?.updatedAt = DateTime.now();
    suspendModel.status?.value = suspendModel.getStatus();
    suspendModel.reason?.value = suspendModel.getReason();
    suspendModel.updateAt = DateTime.now();
    if (kDebugMode) {
      print(suspendModel.status?.value);
    }
    await queryCollectionDB("Review").doc(suspendModel.idUser ?? "").set(
          suspendModel.toJson(),
        );
    if (isSearch.value) {
      listReviewSearch[listReviewSearch.indexOf(suspendModel)] = suspendModel;
    }
    listReviewAll[listReviewAll.indexOf(suspendModel)] = suspendModel;
    var data = {
      "title": "Information",
      "body": (reason.isEmpty)
          ? "Your account has been ${status.capitalizeFirst ?? ""}"
          : reason
    };
    FCMService().sendFCM(
      data: data,
      to: "/topics/" + (suspendModel.idUser ?? ""),
    );
  }
}
