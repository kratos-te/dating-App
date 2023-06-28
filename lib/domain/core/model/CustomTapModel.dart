import 'package:get/state_manager.dart';

class CustomTapModel{
  CustomTapModel({
    required this.name,
    required this.onTap,
  });
  RxString name;
  RxBool onTap;
}