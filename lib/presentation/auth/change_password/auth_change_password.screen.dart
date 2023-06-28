import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/Global.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/general.dart';
import '../../../domain/core/interfaces/widget/alert.dart';
import 'controllers/auth_change_password.controller.dart';

class AuthChangePasswordScreen extends GetView<AuthChangePasswordController> {
  const AuthChangePasswordScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(AuthChangePasswordController()); 
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (Get.width > 600) {
            isLargeScreen = true;
          } else {
            isLargeScreen = false;
          }
          return Obx(
            () => Center(
              child: Container(
                width: isLargeScreen ? Get.width * .5 : Get.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Change id or password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                      elevation: 11,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40),
                        ),
                      ),
                      child: TextField(
                        cursorColor: Theme.of(context).primaryColor,
                        controller: controller.newId,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black26,
                          ),
                          suffixIcon: Icon(
                            Icons.check_circle,
                            color: Colors.black26,
                          ),
                          hintText: "Enter new user-id",
                          hintStyle: TextStyle(color: Colors.black26),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 16.0,
                          ),
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                      elevation: 11,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40),
                        ),
                      ),
                      child: TextField(
                        cursorColor: Theme.of(context).primaryColor,
                        controller: controller.newPasswd,
                        obscureText: !controller.showPass.value,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black26,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            color: controller.showPass.value
                                ? Theme.of(context).primaryColor
                                : Colors.black26,
                            onPressed: () {
                              controller.showPass.value =
                                  !controller.showPass.value;
                            },
                          ),
                          hintText: "Enter new password",
                          hintStyle: TextStyle(
                            color: Colors.black26,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 16.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(30.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          foregroundColor: Theme.of(context).primaryColor,
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                          ),
                        ),
                        child: Text(
                          "Change",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          controller.updateAdminAccount();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
