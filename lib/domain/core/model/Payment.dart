import 'dart:convert';

Payment paymentFromJson(String str) => Payment.fromDocument(json.decode(str));

String paymentToJson(Payment data) => json.encode(data.toJson());

class Payment {
  Payment({
    this.userId = "",
    this.packageId = "",
    this.purchasedId = "",
    this.status = false,
    this.date,
  });

  String userId;
  String packageId;
  String purchasedId;
  bool status;
  DateTime? date;

  factory Payment.fromDocument(Map<String, dynamic> json) => Payment(
    userId: json["userId"],
    packageId: json["packageId"],
    purchasedId: json["purchasedId"],
    status: json["status"],
    date: DateTime.parse(json["date"] ?? DateTime.now().toIso8601String()),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "packageId": packageId,
    "purchasedId" : purchasedId,
    "status": status,
    "date": date?.toIso8601String(),
  };
}
