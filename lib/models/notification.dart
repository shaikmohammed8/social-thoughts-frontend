// To parse this JSON data, do
//
//     final Notification = NotificationFromJson(jsonString);

import 'dart:convert';

Notifications notificationFromJson(String str) =>
    Notifications.fromJson(json.decode(str));

String notificationToJson(Notifications data) => json.encode(data.toJson());

class Notifications {
  Notifications({
    this.seen,
    this.id,
    this.type,
    this.sender,
    this.reciver,
    this.photo,
    this.contentId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  bool seen;
  String id;
  String type;
  Sender sender;
  String reciver;
  String photo;
  String contentId;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        seen: json["seen"],
        id: json["_id"],
        type: json["type"],
        sender: Sender.fromJson(json["sender"]),
        reciver: json["reciver"],
        photo: json['postId'] == null ? null : json["postId"]['photo'],
        contentId: json["contentId"],
        createdAt: DateTime.parse(json["createdAt"]).toLocal(),
        updatedAt: DateTime.parse(json["updatedAt"]).toLocal(),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "seen": seen,
        "_id": id,
        "type": type,
        "sender": sender.toJson(),
        "reciver": reciver,
        "contentId": contentId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class Sender {
  Sender({
    this.profilePic,
    this.id,
    this.name,
  });

  String profilePic;
  String id;
  String name;

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        profilePic: json["profilePic"],
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "profilePic": profilePic,
        "_id": id,
        "name": name,
      };
}
