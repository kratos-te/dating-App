class Routes {
  static Future<String> get initialRoute async {
    return AUTH_SPLASH;
  }

  static const AUTH_CHANGE_PASSWORD = '/auth-change-password';
  static const AUTH_LOGIN = '/auth-login';
  static const AUTH_SPLASH = '/auth-splash';
  static const ITEMACCESS = '/itemaccess';
  static const PACKAGE = '/package';
  static const USER = '/user';
  static const USER_DETAIL = '/user-detail';
  static const USER_REPORT = '/user-report';
  static const VERIFY = '/verify';
  static const USER_REVIEW = '/user-review';
}
