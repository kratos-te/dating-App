// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class CustomWebView extends StatefulWidget {
//   final String selectedUrl;

//   CustomWebView({this.selectedUrl = ""});

//   @override
//   _CustomWebViewState createState() => _CustomWebViewState();
// }

// class _CustomWebViewState extends State<CustomWebView> {
//   // final flutterWebviewPlugin = new FlutterWebviewPlugin();
//   final Completer<WebViewController> _controller = Completer<WebViewController>();
//   @override
//   void initState() {
//     super.initState();
//     // if (url.contains("#access_token")) {
//     //   succeed(url);
//     // }
//     //
//     // if (url.contains(
//     //     "https://www.facebook.com/connect/login_success.html?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied")) {
//     //   denied();
//     // }
//     // flutterWebviewPlugin.onUrlChanged.listen((String url) {
//     //
//     // });
//   }

//   denied() {
//     Navigator.pop(context);
//   }

//   succeed(String url) {
//     var params = url.split("access_token=");

//     var endparam = params[1].split("&");

//     Navigator.pop(context, endparam[0]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: new AppBar(
//           backgroundColor: Color.fromRGBO(66, 103, 178, 1),
//           title: new Text("Facebook login"),
//         ),
//       body: Container(
//         height: Get.height,
//           child: WebView(
//               initialUrl: widget.selectedUrl,
//             onWebViewCreated: (WebViewController webViewController) {
//               _controller.complete(webViewController);
//             },
//             navigationDelegate: (NavigationRequest request) {
//               if (request.url.contains("#access_token")) {
//                 print('Sukses $request}');
//                 succeed(request.url);
//                 // return NavigationDecision.prevent;
//               }
//               if (request.url.contains("https://www.facebook.com/connect/login_success.html?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied")) {
//                 print('blocking navigation to $request}');
//                 denied();
//                 // return NavigationDecision.prevent;
//               }
//               print('allowing navigation to $request');
//               return NavigationDecision.navigate;
//             },
//           )
//       )
//     );
//   }
// }
