import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../../../domain/core/model/user_model.dart';

class Session {
  var storage = GetStorage();

  void saveAuth(bool value) {
    storage.write("isAuth", value);
  }

  bool getAuth() {
    return storage.read("isAuth") ?? false;
  }

  void saveUser(UserModel userModel) async {
    await storage.write("user", jsonEncode(userModel));
  }

  UserModel? getUser() {
    UserModel? userModel;
    String? temp = storage.read("user");
    if (temp != null) {
      userModel = UserModel.fromJson(jsonDecode(temp));
    }
    return userModel;
  }

  void saveIntroduction(bool isIntroduction) async {
    await storage.write("isIntroduction", isIntroduction);
  }

  bool getIntroduction() {
    return storage.read("isIntroduction") ?? false;
  }

  void saveLoginType(String loginType) async {
    await storage.write("metode", loginType);
  }

  String getLoginType() {
    return storage.read("metode") ?? "";
  }

  void saveSwipedUser(List<String> list) async {
    await storage.write("listUidSwiped", list);
  }

  List<String> getSwipedUser() {
    if ((storage.read("listUidSwiped") ?? []).isNotEmpty) {
      return storage.read("listUidSwiped").cast<String>();
    }
    return [];
  }

  void saveToken(String loginType) async {
    await storage.write("token", loginType);
  }

  String getToken() {
    return storage.read("token") ?? "";
  }
}
