class ChatsModel {
  String? imageUrl;
  String? text;
  String? idDoc;
  String? senderId;
  String? type;
  bool? isRead;
  String? receiverId;
  String? time;

  ChatsModel({
    this.imageUrl,
    this.text,
    this.idDoc,
    this.senderId,
    this.type,
    this.isRead,
    this.receiverId,
    this.time,
  });

  ChatsModel.fromJson(Map<String, dynamic> json) {
    idDoc = json['idDoc']?.toString();
    imageUrl = json['image_url']?.toString();
    text = json['text']?.toString();
    senderId = json['sender_id']?.toString();
    type = json['type']?.toString();
    isRead = json['isRead'];
    receiverId = json['receiver_id']?.toString();
    time = json['time']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'image_url': imageUrl,
      'text': text,
      'sender_id': senderId,
      'type': type,
      'isRead': isRead,
      'receiver_id': receiverId,
      'time': time,
    };
  }
}
