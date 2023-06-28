import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'Relationship.dart';
// import 'Relationship.dart';

class UserModel {
  final String id;
  final String name;
  RxBool? isBlocked;
  String address;
  final Map? coordinates;
  final String sexualOrientation;
  final bool showingOrientation;
  final String gender;
  final bool showingGender;
  final List<String> showMe;
  final int age;
  final String phoneNumber;
  int maxDistance;
  Timestamp? lastmsg;
  final Map? ageRange;
  final Map? editInfo;
  List imageUrl = [];
  List<String> listSwipedUser = [];
  var distanceBW;
  final String status;
  final Map? loginID;
  final String metode;
  final List<String> desires;
  final List<String> kinks;
  final List<String> interest;
  final Rxn<Relationship> relasi;
  final String fcmToken;
  final String countryName;
  final String countryID;
  final int verified;
  DateTime? createdAt;

  UserModel({
    required this.id,
    required this.age,
    required this.address,
    this.isBlocked,
    this.coordinates,
    required this.name,
    required this.imageUrl,
    this.phoneNumber = "",
    // this.lastmsg,
    this.gender = "",
    this.showingGender = false,
    this.showMe = const [],
    this.ageRange,
    this.maxDistance = 0,
    this.editInfo,
    this.distanceBW,
    this.sexualOrientation = "",
    this.showingOrientation = false,
    this.status = "",
    this.desires = const [],
    this.kinks = const [],
    this.interest = const [],
    required this.loginID,
    required this.metode,
    required this.relasi,
    this.fcmToken = "",
    this.countryName = "",
    this.listSwipedUser = const [],
    this.countryID = "",
    this.verified = 0,
    this.createdAt,
  });

  // factory UserModel.fromDocument(Document doc) {
  //   return UserModel(
  //     id: doc['userId'],
  //     // isBlocked: doc['isBlocked'] != null ? doc['isBlocked'] : false,
  //     isBlocked: doc.map.containsKey('isBlocked')
  //         ? doc['isBlocked']
  //         : false,
  //     phoneNumber: doc.map.containsKey('phoneNumber')
  //         ? doc['phoneNumber'] ?? ""
  //         : "",
  //     name: doc['UserName'],
  //     editInfo: doc['editInfo'],
  //     ageRange: doc['age_range'],
  //     showMe: List.generate((doc.map['showGender'] ?? []).length, (index) {
  //             return doc[index];
  //           }),
  //     gender: doc['editInfo']['userGender'] ?? "woman",
  //     showingGender: doc['editInfo']['showOnProfile'] ?? true,
  //     maxDistance: doc['maximum_distance'],
  //     sexualOrientation: doc['sexualOrientation']['orientation'] ?? "",
  //     showingOrientation: doc['sexualOrientation']['showOnProfile'] ?? "",
  //     status: doc['status'] ?? 'single',
  //     desires: doc['desires'] ?? [],
  //     kinks: doc.data().toString().contains('kinks') ? doc['kinks'] : [],
  //     interest:
  //         doc.data().toString().contains('interest') ? doc['interest'] : [],
  //     age:
  //         ((DateTime.now().difference(DateTime.parse(doc["user_DOB"])).inDays) /
  //                 365.2425)
  //             .truncate(),
  //     address: doc['location']['address'],
  //     coordinates: doc['location'],
  //     countryName: doc['location']['countryName'] ?? "",
  //     countryID: doc['location']['countryID'] ?? "",
  //     loginID: doc.data().toString().contains('LoginID') ? doc['LoginID'] : {},
  //     metode: doc.data().toString().contains('metode') ? doc['metode'] : "",
  //     // university: doc['editInfo']['university'],
  //     imageUrl: doc['Pictures'] != null
  //         ? List.generate(doc['Pictures'].length, (index) {
  //             return doc['Pictures'][index];
  //           })
  //         : [],
  //     listSwipedUser: doc.data().toString().contains('listSwipedUser')
  //         ? doc['listSwipedUser']
  //         : [],
  //     relasi: Rxn(),
  //     fcmToken:
  //         doc.data().toString().contains('pushToken') ? doc['pushToken'] : "",
  //     verified:
  //         doc.data().toString().contains('verified') ? doc['verified'] : 0,
  //   );
  // }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // print(json['timestamp'].runtimeType);
    return UserModel(
      id: json['userId'],
      isBlocked: json['isBlocked'] == true ? true.obs : false.obs,
      phoneNumber: json['phoneNumber'] ?? "",
      name: json['UserName'] ?? "",
      editInfo: json['editInfo'],
      ageRange: json['age_range'],
      showMe: List.generate((json['showGender'] ?? []).length, (index) {
        return json['showGender'][index];
      }),
      gender: json['editInfo']['userGender'] ?? "woman",
      showingGender: json['editInfo']['showOnProfile'] ?? true,
      maxDistance: json['maximum_distance'] ?? 0,
      sexualOrientation: json['sexualOrientation']['orientation'] ?? "",
      showingOrientation: json['sexualOrientation']['showOnProfile'] ?? false,
      status: json['status'] ?? 'single',
      desires: List.generate((json['desires'] ?? []).length, (index) {
        return json['desires'][index];
      }),
      kinks: List.generate((json['kinks'] ?? []).length, (index) {
        return json['kinks'][index];
      }),
      interest: List.generate((json['interest'] ?? []).length, (index) {
        return json['interest'][index];
      }),
      age: ((DateTime.now()
                  .difference(DateTime.parse(json["user_DOB"]))
                  .inDays) /
              365.2425)
          .truncate(),
      address: json['location']['address'] ?? "",
      coordinates: json['location'],
      countryName: json['location']['countryName'] ?? "",
      countryID: json['location']['countryID'] ?? "",
      loginID: json['LoginID'],
      metode: json['metode'] ?? "",
      // university: doc['editInfo']['university'],
      imageUrl: List.generate((json['Pictures'] ?? []).length, (index) {
        return json['Pictures'][index];
      }),
      listSwipedUser:
          List.generate((json['listSwipedUser'] ?? []).length, (index) {
        return json['listSwipedUser'][index];
      }),
      relasi: Rxn(),
      fcmToken: json['pushToken'] ?? "",
      verified: json['verified'] ?? 0,
    );
  }

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       // isBlocked: doc['isBlocked'] != null ? doc['isBlocked'] : false,
  //       "isBlocked": isBlocked,
  //       "phoneNumber": phoneNumber,
  //       "UserName": name,
  //       "editInfo": editInfo,
  //       'age_range': ageRange,
  //       "showGender": showMe,
  //       gender: doc['editInfo']['userGender'] ?? "woman",
  //       showingGender: doc['editInfo']['showOnProfile'] ?? true,
  //       maxDistance: doc['maximum_distance'],
  //       sexualOrientation: doc['sexualOrientation']['orientation'] ?? "",
  //       showingOrientation: doc['sexualOrientation']['showOnProfile'] ?? "",
  //       status: doc['status'] ?? 'single',
  //       desires: doc['desires'] ?? [],
  //       kinks: doc.data().toString().contains('kinks') ? doc['kinks'] : [],
  //       interest:
  //           doc.data().toString().contains('interest') ? doc['interest'] : [],
  //       age: ((DateTime.now()
  //                   .difference(DateTime.parse(doc["user_DOB"]))
  //                   .inDays) /
  //               365.2425)
  //           .truncate(),
  //       address: doc['location']['address'],
  //       coordinates: doc['location'],
  //       countryName: doc['location']['countryName'] ?? "",
  //       countryID: doc['location']['countryID'] ?? "",
  //       loginID:
  //           doc.data().toString().contains('LoginID') ? doc['LoginID'] : {},
  //       metode: doc.data().toString().contains('metode') ? doc['metode'] : "",
  //       // university: doc['editInfo']['university'],
  //       imageUrl: doc['Pictures'] != null
  //           ? List.generate(doc['Pictures'].length, (index) {
  //               return doc['Pictures'][index];
  //             })
  //           : [],
  //       listSwipedUser: doc.data().toString().contains('listSwipedUser')
  //           ? doc['listSwipedUser']
  //           : [],
  //       // relasi: null,
  //       fcmToken:
  //           doc.data().toString().contains('pushToken') ? doc['pushToken'] : "",
  //       verified:
  //           doc.data().toString().contains('verified') ? doc['verified'] : 0,
  //     };
}
