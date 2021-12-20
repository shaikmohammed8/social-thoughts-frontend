// To parse this JSON data, do
//
//     final User = UserFromJson(jsonString);

class User {
  User(
      {this.id,
      this.follower,
      this.following,
      this.email,
      this.name,
      this.username,
      this.createdAt,
      this.updatedAt,
      this.profilePic});

  String id;
  String email;
  String name;
  String username;
  DateTime createdAt;
  List follower;
  List following;
  String profilePic;
  DateTime updatedAt;

  factory User.fromJson(Map<String, dynamic> json) =>
      json["createdAt"] == null || json["updatedAt"] == null
          ? User(
              follower: json['follower'],
              following: json['following'],
              id: json["_id"],
              email: json["email"],
              name: json["name"],
              username: json["username"],
              profilePic: json['profilePic'])
          : User(
              follower: json['follower'],
              following: json['following'],
              id: json["_id"],
              email: json["email"],
              name: json["name"],
              username: json["username"],
              createdAt: DateTime.parse(json["createdAt"]).toLocal(),
              updatedAt: DateTime.parse(json["updatedAt"]).toLocal(),
              profilePic: json['profilePic']);

  Map<String, dynamic> toJson() => {
        'follower': follower,
        'following': following,
        "_id": id,
        "email": email,
        "name": name,
        "username": username,
        "createdAt": createdAt.toIso8601String(),
        "profilePic": profilePic,
        "updatedAt": updatedAt.toIso8601String(),
      };
}
