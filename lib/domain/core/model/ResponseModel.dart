
import 'package:get/get_connect/connect.dart';

class ResponseModel{
  ResponseModel({
    required this.isError,
    required this.result,
    required this.msg,
  });

  String msg;
  bool isError;
  Response? result;
}