

import 'package:cloud_firestore/cloud_firestore.dart';

class Relationship {
  Relationship({
    this.userId,
    this.partner,
    this.inRelationship,
    this.pendingReq = const [],
    this.pendingAcc = const [],
    this.updateAt,
  });

  String? userId;
  Partner? partner;
  bool? inRelationship;
  List<Pending> pendingReq;
  List<Pending> pendingAcc;
  DateTime? updateAt;

  factory Relationship.fromDocument(Map<String, dynamic> json) {
    // print("Cek updateAt");
    // print(json['updateAt']);
    return Relationship(
      userId: json["userId"],
      partner: Partner.fromDocument(json["partner"]),
      inRelationship: json["inRelationship"],
      pendingReq: List<Pending>.from(json["pendingReq"].map((x) => Pending.fromDocument(x))),
      pendingAcc: List<Pending>.from(json["pendingAcc"].map((x) => Pending.fromDocument(x))),
      updateAt: (json['updateAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "partner": partner?.toJson(),
    "inRelationship": inRelationship,
    "pendingReq": List<dynamic>.from(pendingReq.map((x) => x.toJson())),
    "pendingAcc": List<dynamic>.from(pendingAcc.map((x) => x.toJson())),
    "updateAt": Timestamp.fromDate(updateAt ?? DateTime.now()),
  };
}

class Pending {
  Pending({
    this.createdAt,
    this.reqUid = "",
    this.imageUrl = "",
    this.userName = "",
  });

  DateTime? createdAt;
  String reqUid;
  String imageUrl;
  String userName;

  factory Pending.fromDocument(Map<String, dynamic> json) => Pending(
    createdAt: (json['createdAt'] as Timestamp).toDate(),
    reqUid: json["reqUid"],
    imageUrl: json["imageUrl"],
    userName: json["userName"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": Timestamp.fromDate(createdAt ?? DateTime.now()),
    "reqUid": reqUid,
    "imageUrl" : imageUrl,
    "userName" : userName,
  };
}


class Partner {
  Partner({
    this.partnerId = "",
    this.partnerImage = "",
    this.partnerName = "",
  });

  String partnerId;
  String partnerImage;
  String partnerName;

  factory Partner.fromDocument(Map<String, dynamic> json) => Partner(
    partnerId: json["partnerId"],
    partnerImage: json["partnerImage"],
    partnerName: json["partnerName"],
  );

  Map<String, dynamic> toJson() => {
    "partnerId": partnerId,
    "partnerImage": partnerImage,
    "partnerName": partnerName,
  };
}
