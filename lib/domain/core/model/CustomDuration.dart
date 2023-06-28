import 'package:get/get.dart';

class CustomDuration {
  CustomDuration({
    required this.name,
    required this.type,
    required this.duration,
    required this.isTouch,
  });

  String name;
  String type;
  int duration;
  RxBool isTouch;
}
