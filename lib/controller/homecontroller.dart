import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:twitter_clone/models/tweets.dart';
import 'package:twitter_clone/repositories/postRepository.dart';
import 'package:twitter_clone/services/socket.io.dart';

class HomeController extends GetxController {
  var postRepo = PostRepository();
  var url = "api/posts/following/post?skip=0".obs;

  int i = 0;
  var isWaiting = false.obs;
  RxList<Tweet> tweets = <Tweet>[].obs;
  ScrollController sController = ScrollController();
  onInit() {
    SocketHandler.socket.on('like', (data) {
      List likes = data['likes'];

      for (i = 0; i < tweets.length; i++) {
        var tweet = tweets[i];

        if (tweet.id == data['_id']) {
          tweet.likes = likes;
          tweets[i] = tweet;
          return;
        }
      }
    });
    SocketHandler.socket.on('retweet', (data) {
      List retweets = data['retweets'];
      for (i = 0; i < tweets.length; i++) {
        var tweet = tweets[i];

        if (tweet.id == data['_id']) {
          tweet.retweets = retweets;
          tweets[i] = tweet;
          return;
        }
      }
    });
    sController.addListener(() async {
      isWaiting.value = true;
      if (sController.position.pixels == sController.position.maxScrollExtent) {
        var list = await postRepo
            .getPosts("api/posts/following/post?skip=${tweets.length}");
        tweets.addAll(list);
        isWaiting.value = false;
      }
    });
    super.onInit();
  }

  refresList() {}
}
