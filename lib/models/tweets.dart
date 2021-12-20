// To parse this JSON data, do
//
//     final tweet = tweetFromJson(jsonString);

List<Tweet> tweetFromJson(List str) =>
    List<Tweet>.from(str.map((x) => Tweet.fromJson(x)));

List tweetToJson(List<Tweet> data) =>
    List<dynamic>.from(data.map((x) => x.toJson()));

class Tweet {
  Tweet({
    this.isLiked,
    this.likes,
    this.retweets,
    this.id,
    this.content,
    this.hasPostdata,
    this.tweetby,
    this.postBy,
    this.createdAt,
    this.postData,
    this.photo,
    this.reply,
    this.v,
  });
  Tweet postData;
  bool isLiked;
  List<dynamic> likes;
  List<dynamic> retweets;
  String id;
  List<Reply> reply;
  String photo;
  String content;
  PostBy tweetby;
  PostBy postBy;
  bool hasPostdata;
  DateTime createdAt;
  int v;

  factory Tweet.fromJson(Map<String, dynamic> json) {
    if (json['postData'] != null) {
      return Tweet(
          id: json['_id'],
          postBy: PostBy.fromJson(json['postBy']),
          postData: Tweet.fromJson(json['postData']));

      // Tweet(

      //   tweetby: PostBy.fromJson(json["postBy"]),
      //   isLiked: json['postData']["isLiked"],
      //   likes: List<dynamic>.from(json['postData']["likes"].map((x) => x)),
      //   retweets:
      //       List<dynamic>.from(json['postData']["retweets"].map((x) => x)),
      //   hasPostdata: true,
      //   id: json['postData']["_id"],
      //   content: json['postData']["content"],
      //   postBy: PostBy.fromJson(json['postData']["postBy"]),
      //   createdAt: DateTime.parse(json['postData']["createdAt"]),
      //   photo: json['postData']['photo'],
      //   postData: json['postData']['postData'],
      //   reply: json['postData']['reply'] == null
      //       ? null
      //       : List<Reply>.from(
      //           json['postData']["reply"].map((x) => Reply.fromJson(x))),
      //   v: json['postData']["__v"],
      // );
    }
    var t = Tweet(
      isLiked: json["isLiked"],
      likes: List<dynamic>.from(json["likes"].map((x) => x)),
      retweets: List<dynamic>.from(json["retweets"].map((x) => x)),
      hasPostdata: false,
      id: json["_id"],
      content: json["content"],
      postBy: PostBy.fromJson(json["postBy"]),
      createdAt: DateTime.parse(json["createdAt"]).toLocal(),
      photo: json['photo'],
      postData: json['postData'],
      reply: json['reply'] == null
          ? null
          : List<Reply>.from(json["reply"].map((x) => Reply.fromJson(x))),
      v: json["__v"],
    );
    return t;
  }
  Map<String, dynamic> toJson() => {
        "isLiked": isLiked,
        "likes": List<dynamic>.from(likes.map((x) => x)),
        "retweets": List<dynamic>.from(retweets.map((x) => x)),
        "_id": id,
        "content": content,
        "postBy": postBy.toJson(),
        "reply": List<dynamic>.from(reply.map((x) => x.toJson())),
        "createdAt": createdAt.toIso8601String(),
        "__v": v,
      };
}

class PostBy {
  PostBy({this.id, this.name, this.username, this.profilePic});

  String id;
  String name;
  String username;
  String profilePic;

  factory PostBy.fromJson(Map<String, dynamic> json) {
    return PostBy(
        id: json["_id"],
        name: json["name"],
        username: json['username'],
        profilePic: json['profilePic']);
  }
  Map<String, dynamic> toJson() =>
      {"_id": id, "name": name, 'username': username, 'profilePic': profilePic};
}

class Reply {
  Reply({
    this.id,
    this.reply,
    this.userId,
  });

  String id;
  String reply;
  PostBy userId;

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        id: json["_id"],
        reply: json["reply"],
        userId: PostBy.fromJson(json["userId"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "reply": reply,
        "userId": userId.toJson(),
      };
}
