import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unjabbed_admin/domain/core/interfaces/widget/loading.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/Global.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/session.dart';
import '../../../infrastructure/dal/util/general.dart';
import '../../../infrastructure/navigation/routes.dart';
import 'controllers/auth_login.controller.dart';

class AuthLoginScreen extends GetView<AuthLoginController> {
  const AuthLoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(AuthLoginController());
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
                  children: <Widget>[
                    Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0,
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
                        controller: controller.username,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black26,
                          ),
                          suffixIcon: Icon(
                            Icons.check_circle,
                            color: Colors.black26,
                          ),
                          hintText: "Username",
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
                        controller: controller.password,
                        obscureText: !controller.showPass.value,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black26,
                          ),
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: Colors.black26,
                          ),
                          filled: true,
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
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(30.0),
                      child: controller.isLoading.value
                          ? loadingWidget(null, null)
                          : ElevatedButton(
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
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                bool isValid = await controller.login(
                                    controller.username.text,
                                    controller.password.text);
                                Global().showInfoDialog(
                                  isValid
                                      ? "Logged in Successfully..."
                                      : "Incorrect Username or Password!",
                                );
                                if (isValid) {
                                  await Future.delayed(Duration(seconds: 1));
                                  Session().saveAuth(true);
                                  // await globalController.initAfterLogin();
                                  Get.toNamed(Routes.USER);
                                }
                                controller.isLoading.value = false;
                              },
                            ),
                    ),
                    // Text("Forgot your password?",
                    //     style: TextStyle(color: Theme.of(context).primaryColor))
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
