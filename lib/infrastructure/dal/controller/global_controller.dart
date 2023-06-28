import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:unjabbed_admin/domain/core/model/user_model.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/general.dart';

import '../services/fcm_service.dart';

class GlobalController extends GetxController {
  // RxList<UserModel> listUser = RxList();

  // initAfterLogin() async {
  //   var listDoc = await queryCollectionDB("Users")
  //       .orderBy("user_DOB", descending: true)
  //       .get();
  //   if (listDoc.isNotEmpty) {
  //     for (var doc in listDoc) {
  //       listUser.add(UserModel.fromJson(doc.map));
  //     }
  //   }
  // }

  sendLikedFCM({required String idUser, required String name}) async {
    String toParams = "/topics/" + idUser;
    var data = {
      "title": "Liked",
      "body": "Someone just liked your profile! Tap to see if you're a match!",
      "idUser": idUser,
    };
    var notif = {
      "title": "Liked",
      "body": "Someone just liked your profile! Tap to see if you're a match!"
    };
    if (kDebugMode) {
      print(data);
    }
    var response = await FCMService()
        .sendCustomFCM(data: data, to: toParams, notif: notif);
    if (kDebugMode) {
      print(response);
    }
  }

  sendChatFCM({required String idUser, required String name}) async {
    // UserModel userFCM = Get.find<TabsController>().getUserSelected(idUser);
    if (kDebugMode) {
      print("Send Message FCM");
    }
    String toParams = "/topics/" + idUser;
    var data = {"title": "New Chat", "body": "You have new message from $name"};
    var response = await FCMService().sendFCM(data: data, to: toParams);
    if (kDebugMode) {
      print(response);
    }
  }

  sendLeaveFCM({required String idUser, required String name}) async {
    // UserModel userFCM = Get.find<TabsController>().getUserSelected(idUser);
    if (kDebugMode) {
      print("Send Leave FCM");
    }
    String toParams = "/topics/" + idUser;
    var data = {
      "title": "Leaving Chat",
      "body": "$name has left the conversation"
    };
    var response = await FCMService().sendFCM(data: data, to: toParams);
    if (kDebugMode) {
      print(response);
    }
  }

  sendRestoreLeaveFCM({required String idUser, required String name}) async {
    // UserModel userFCM = Get.find<TabsController>().getUserSelected(idUser);
    if (kDebugMode) {
      print("Send Restore Leave FCM");
    }
    String toParams = "/topics/" + idUser;
    var data = {
      "title": "Resume Chat",
      "body": "$name has resumed the conversation"
    };
    var response = await FCMService().sendFCM(data: data, to: toParams);
    if (kDebugMode) {
      print(response);
    }
  }

  sendDisconnectFCM({required String idUser, required String name}) async {
    // UserModel userFCM = Get.find<TabsController>().getUserSelected(idUser);
    if (kDebugMode) {
      print("Send Blocked FCM");
    }
    String toParams = "/topics/" + idUser;
    var data = {"title": "Blocked Chat", "body": "$name has blocked you"};
    var response = await FCMService().sendFCM(data: data, to: toParams);
    if (kDebugMode) {
      print(response);
    }
  }
}
