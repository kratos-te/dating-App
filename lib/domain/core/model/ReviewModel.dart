// To parse this JSON data, do
//
//     final suspendModel = suspendModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

ReviewModel? suspendModelFromJson(String str) =>
    ReviewModel.fromJson(json.decode(str));

String suspendModelToJson(ReviewModel? data) => json.encode(data!.toJson());

class ReviewModel {
  ReviewModel({
    this.idUser,
    this.listImage,
    this.name,
    this.status,
    this.reason,
    this.updateAt,
    this.createdAt,
  });

  String? idUser;
  List<ListImage?>? listImage;
  String? name;
  Rxn<String>? status;
  Rxn<String>? reason;
  DateTime? updateAt;
  DateTime? createdAt;

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        idUser: json["idUser"],
        listImage: json["listImage"] == null
            ? []
            : List<ListImage?>.from(
                json["listImage"]!.map((x) => ListImage.fromJson(x))),
        name: json["name"],
        status: Rxn(),
        reason: Rxn(),
        updateAt: DateTime.parse(json["updated_at"].runtimeType == DateTime
            ? json['updated_at'].toIso8601String()
            : json['updated_at']),
        createdAt: DateTime.parse(json["created_at"].runtimeType == DateTime
            ? json["created_at"].toIso8601String()
            : json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "idUser": idUser,
        "listImage": listImage == null
            ? []
            : List<dynamic>.from(listImage!.map((x) => x!.toJson())),
        "name": name,
        "updated_at": updateAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
      };

  String getStatus() {
    if ((listImage ?? []).isNotEmpty) {
      return listImage?.last?.status ?? "";
    }
    return "";
  }

  String getReason() {
    if ((listImage ?? []).isNotEmpty) {
      return listImage?.last?.reason ?? "";
    }
    return "";
  }
}

class ListImage {
  ListImage({
    this.imageUrl,
    this.status,
    this.reason,
    this.createdAt,
    this.updatedAt,
  });

  String? imageUrl;
  String? status;
  String? reason;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ListImage.fromJson(Map<String, dynamic> json) => ListImage(
        imageUrl: json["imageUrl"],
        status: json["status"],
        reason: json["reason"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "imageUrl": imageUrl,
        "status": status,
        "reason": reason,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
