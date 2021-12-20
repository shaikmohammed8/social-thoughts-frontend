import 'package:twitter_clone/models/notification.dart';
import 'package:twitter_clone/models/user.dart';
import 'package:twitter_clone/services/NetworkHandler.dart';

class UserReposiotry {
  var network = NetworkHandler();
  Future<User> getUser(String url) async {
    var res = await network.getCall(url);
    if (res['code'] == 200) {
      return User.fromJson(res['body']);
    } else
      print(res['body']);
    return null;
  }

  Future<List<User>> searchUsers(String url) async {
    var res = await network.getCall(url);
    if (res['code'] == 200) {
      print(url);
      return List<User>.from(res['body'].map((x) => User.fromJson(x)));
    } else
      print(res['body']);
    return null;
  }

  updateUser(
    String url,
  ) async {
    var res = await network.putCall(url);
    if (res['code'] == 200) {
      print(res['body']);
    } else
      print(res['body']);
    return null;
  }

  Future<List<Notifications>> getNotifications(String url) async {
    var res = await network.getCall(url);
    if (res['code'] == 200) {
      return List<Notifications>.from(
          res['body'].map((x) => Notifications.fromJson(x)));
    } else {
      print(res['body']);
      return null;
    }
  }
}
