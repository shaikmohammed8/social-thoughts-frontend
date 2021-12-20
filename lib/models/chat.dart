import 'dart:convert';

import 'package:twitter_clone/models/message.dart';
import 'package:twitter_clone/models/user.dart';

Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

String chatToJson(Chat data) => json.encode(data.toJson());

class Chat {
  Chat({
    this.isGroupChat,
    this.users,
    this.photo,
    this.id,
    this.lastMessage,
    this.chatName,
    this.seenBy,
  });

  bool isGroupChat;
  List<User> users;
  String photo;
  String id;
  List<dynamic> seenBy;
  Message lastMessage;
  String chatName;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        isGroupChat: json["isGroupChat"],
        users: json['users'] == null
            ? null
            : List<User>.from(json["users"].map((x) => User.fromJson(x))),
        photo: json["photo"],
        id: json["_id"],
        seenBy: json["seenBy"],
        lastMessage: json['lastMessage'] == null
            ? null
            : Message.fromJson(json['lastMessage']),
        chatName: json["ChatName"],
      );

  Map<String, dynamic> toJson() => photo == null
      ? {
          "isGroupChat": isGroupChat,
          "users": List<dynamic>.from(users.map((x) => x.id)),
          "_id": id,
          "ChatName": chatName,
        }
      : {
          "isGroupChat": isGroupChat,
          "users": List<dynamic>.from(users.map((x) => x.id)),
          "photo": photo,
          "_id": id,
          "ChatName": chatName,
        };
}
