class RoomModel {
  bool? active;
  String? docId;
  bool? isclear1;
  bool? isclear2;

  RoomModel({
    this.active,
    this.docId,
    this.isclear1,
    this.isclear2,
  });

  RoomModel.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    docId = json['docId'];
    isclear1 = json['isclear1'];
    isclear2 = json['isclear2'];
  }

  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'docId': docId,
      'isclear1': isclear1,
      'isclear2': isclear2,
    };
  }
}
