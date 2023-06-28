// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// showSimpleNotification({required String title, required String body}) async {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   const AndroidNotificationDetails androidplatformChannelSpecifics =
//       AndroidNotificationDetails('your channel id', 'your channel name',
//           importance: Importance.max,
//           priority: Priority.high,
//           ticker: 'ticker');
//   const IOSNotificationDetails iOSplatformChannelSpecifics =
//       IOSNotificationDetails(presentSound: false);
//   const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidplatformChannelSpecifics,
//       iOS: iOSplatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.show(
//     0, title, body, platformChannelSpecifics,
//     // payload:payload
//   );
// }
