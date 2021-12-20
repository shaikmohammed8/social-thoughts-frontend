// To parse this JSON data, do
//
//     final message = messageFromJson(jsonString);

import 'dart:convert';

List<Message> messageFromJson(List l) =>
    List<Message>.from(l.map((x) => Message.fromJson(x)));

String messageToJson(List<Message> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Message {
  Message({
    this.id,
    this.message,
    this.sender,
    this.chat,
    this.uuid,
    this.photo,
    this.updatedAt,
    this.v,
  });

  String uuid;
  String photo;
  String id;
  String message;
  Sender sender;
  String chat;
  DateTime updatedAt;
  int v;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["_id"],
        message: json["message"],
        uuid: json['uuid'] == null ? null : json['uuid'],
        photo: json['photo'] == null ? null : json['photo'],
        sender: json['sender'] == null ? null : Sender.fromJson(json["sender"]),
        chat: json["chat"],
        updatedAt: DateTime.parse(json["updatedAt"]).toLocal(),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "message": message,
        "chat": chat,
        "photo": photo,
        'uuid': uuid
      };
}

class Sender {
  Sender({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
