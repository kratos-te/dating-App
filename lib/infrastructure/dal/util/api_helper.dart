import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/session.dart';
import '../../../config.dart';
import '../../../domain/core/model/ResponseModel.dart';
import 'general.dart';

class ApiHelper extends GetConnect {
  GetStorage storage = GetStorage();
  var url = ConfigEnvironments.getEnvironments()['url']!;
  final int timeOut = 120;

  Future<ResponseModel> postApi(String urlPrefix, Object body,
      {int header = 0}) async {
    var urlS = url + urlPrefix;
    if (header == 2) {
      urlS = urlFcm + urlPrefix;
    }
    if (kDebugMode) {
      // print(header);
      print("ambil data Post : $urlS");
      print(body);
    }
    try {
      final Response response =
          await post(urlS, body, headers: headerCheck(choice: header))
              .timeout(Duration(seconds: timeOut));
      return ResponseModel(
          isError: false, result: response, msg: "Success Get Data");
    } on TimeoutException catch (e) {
      throw "Connection Timeout, please check your connection";
    } catch (e) {
      return ResponseModel(isError: true, result: null, msg: e.toString());
    }
  }

  Future<ResponseModel> getApi(String urlPrefix, Map<String, dynamic>? query,
      {int header = 0}) async {
    var urlS = url + urlPrefix;
    if (header == 2) {
      urlS = urlFcm + urlPrefix;
    }
    if (kDebugMode) {
      print("ambil data Get : $urlS");
      print(timeOut);
    }
    try {
      final Response response = await get(
        urlS,
        query: query,
        headers: headerCheck(choice: header),
      ).timeout(Duration(seconds: timeOut));

      return ResponseModel(
          isError: false, result: response, msg: "Success Get Data");
    } on TimeoutException catch (e) {
      throw "Connection Timeout, please check your connection";
    } catch (e) {
      return ResponseModel(isError: true, result: null, msg: e.toString());
    }
  }

  Future<ResponseModel> path(String urlPrefix, Object body,
      {int header = 0}) async {
    var urlS = url + urlPrefix;
    if (header == 2) {
      urlS = urlFcm + urlPrefix;
    }
    if (kDebugMode) {
      // print(header);
      print("ambil data Post : $urlS");
      print(body);
    }
    try {
      final Response response =
          await patch(urlS, body, headers: headerCheck(choice: header))
              .timeout(Duration(seconds: timeOut));
      return ResponseModel(
          isError: false, result: response, msg: "Success Get Data");
    } on TimeoutException catch (e) {
      throw "Connection Timeout, please check your connection";
    } catch (e) {
      return ResponseModel(isError: true, result: null, msg: e.toString());
    }
  }

  headerLogin() {
    String token = Session().getToken();
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
  }

  headerFCM() {
    return {
      "Authorization": "key=$apiKeyFcm",
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
  }

  Map<String, String>? headerCheck({int choice = 0}) {
    if (choice == 1) {
      return headerLogin();
    }
    if (choice == 2) {
      return headerFCM();
    }
    return null;
  }
}
