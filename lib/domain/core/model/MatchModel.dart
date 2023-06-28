// To parse this JSON data, do
//
//     final matchModel = matchModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

// MatchModel? matchModelFromJson(String str) =>
//     MatchModel.fromJson(json.decode(str));

// String matchModelToJson(MatchModel? data) => json.encode(data!.toJson());

class MatchModel {
  MatchModel({
    this.matches,
    this.isRead,
    this.pictureUrl,
    this.userName,
    this.lastMsg = "",
    required this.type,
    this.timeStamp,
  });

  String? matches;
  bool? isRead;
  String? pictureUrl;
  String? userName;
  String lastMsg;
  RxInt type;
  DateTime? timeStamp;

  // factory MatchModel.fromJson(Map<String, dynamic> json) => MatchModel(
  //     matches: json["Matches"],
  //     isRead: json["isRead"],
  //     pictureUrl: json["pictureUrl"],
  //     userName: json["userName"],
  //     // type : json["type"],
  //     timeStamp: DateTime.parse(json['timestamp']));

  // Map<String, dynamic> toJson() => {
  //       "Matches": matches,
  //       "isRead": isRead,
  //       "pictureUrl": pictureUrl,
  //       "userName": userName,
  //       "type": type.value,
  //       "timestamp": timeStamp != null
  //           ? timeStamp!.toIso8601String()
  //           : DateTime.now().toIso8601String()
  //     };
}
