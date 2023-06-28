import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/api_helper.dart';
import '../util/Global.dart';

class FCMService {
  Future<bool> sendFCM(
      {required Map<String, dynamic> data, required String to}) async {
    try {
      String urlPrefix = "send";
      var response = await ApiHelper().postApi(
        urlPrefix,
        json.encode({
          "notification": data,
          "data": data,
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "to": to
        }),
        header: 2,
      );
      if (kDebugMode) {
        print(response.msg);
        print(response.result?.bodyString);
      }
      if (!response.isError) {
        return true;
      }
      Global().showInfoDialog(response.msg);
      return false;
    } catch (e) {
      print(e.toString());
      Global().showInfoDialog(e.toString());
      return false;
    }
  }

  Future<bool> sendCustomFCM({
    required Map<String, String> data,
    required Map<String, String> notif,
    required String to,
  }) async {
    try {
      String urlPrefix = "send";
      var response = await ApiHelper().postApi(
        urlPrefix,
        json.encode({
          "notification": notif,
          "data": data,
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "to": to
        }),
        header: 2,
      );
      if (kDebugMode) {
        print(response.msg);
        print(response.result?.bodyString);
      }
      if (!response.isError) {
        return true;
      }
      Global().showInfoDialog(response.msg);
      return false;
    } catch (e) {
      print(e.toString());
      Global().showInfoDialog(e.toString());
      return false;
    }
  }
}
