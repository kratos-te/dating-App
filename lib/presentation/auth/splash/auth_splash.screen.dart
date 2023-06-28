import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/auth_splash.controller.dart';

class AuthSplashScreen extends GetView<AuthSplashController> {
  const AuthSplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(AuthSplashController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 120,
          width: 200,
          child: Image.asset(
            "assets/hookup4u-Logo-BP.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
