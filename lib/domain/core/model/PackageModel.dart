class PackageModel {
  String? description;
  bool? status;
  DateTime? timestamp;
  String? title;
  String? id;

  PackageModel({
    this.description,
    this.status,
    this.timestamp,
    this.title,
    this.id,
  });

  PackageModel.fromJson(Map<String, dynamic> json) {
    description = json['description']?.toString();
    status = json['status'];
    timestamp = json['timestamp'].toDate();
    title = json['title']?.toString();
    id = json['id']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'status': status,
      'timestamp': timestamp?.toIso8601String(),
      'title': title,
      'id': id,
    };
  }
}