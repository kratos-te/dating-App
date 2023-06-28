import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:unjabbed_admin/presentation/user/home_screen.dart';

import '../../config.dart';
import '../../presentation/screens.dart';
import 'bindings/controllers/controllers_bindings.dart';
import 'routes.dart';

class EnvironmentsBadge extends StatelessWidget {
  final Widget child;
  EnvironmentsBadge({required this.child});
  @override
  Widget build(BuildContext context) {
    var env = ConfigEnvironments.getEnvironments()['env'];
    return env != Environments.PRODUCTION
        ? Banner(
            location: BannerLocation.topStart,
            message: env!,
            color: env == Environments.QAS ? Colors.blue : Colors.purple,
            child: child,
          )
        : SizedBox(child: child);
  }
}

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.AUTH_LOGIN,
      page: () => const AuthLoginScreen(),
      binding: AuthLoginControllerBinding(),
    ),
    GetPage(
      name: Routes.AUTH_SPLASH,
      page: () => const AuthSplashScreen(),
      binding: AuthSplashControllerBinding(),
    ),
    GetPage(
      name: Routes.USER,
      page: () => const HomeScreen(),
      binding: UserControllerBinding(),
    ),
    GetPage(
      name: Routes.USER_DETAIL + "/:idUser",
      page: () => UserDetailScreen(),
      binding: UserDetailControllerBinding(),
    ),
    GetPage(
      name: Routes.PACKAGE,
      page: () => const PackageScreen(),
      binding: PackageControllerBinding(),
    ),
    GetPage(
      name: Routes.ITEMACCESS,
      page: () => ItemaccessScreen(),
      binding: ItemaccessControllerBinding(),
    ),
    GetPage(
      name: Routes.AUTH_CHANGE_PASSWORD,
      page: () => const AuthChangePasswordScreen(),
      binding: AuthChangePasswordControllerBinding(),
    ),
    GetPage(
      name: Routes.VERIFY,
      page: () => VerifyScreen(),
      binding: VerifyControllerBinding(),
    ),
    GetPage(
      name: Routes.USER_REPORT,
      page: () => UserReportScreen(),
      binding: UserReportControllerBinding(),
    ),
    GetPage(
      name: Routes.USER_REVIEW,
      page: () => const UserReviewScreen(),
      binding: UserReviewControllerBinding(),
    ),
  ];
}
