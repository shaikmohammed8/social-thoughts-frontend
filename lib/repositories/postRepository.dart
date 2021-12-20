import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/models/tweets.dart';
import 'package:twitter_clone/services/NetworkHandler.dart';
import 'package:twitter_clone/services/socket.io.dart';

class PostRepository {
  var network = NetworkHandler();

  // ignore: missing_return
  Future<List<Tweet>> getPosts(String url) async {
    try {
      var res = await network.getCall(url);
      return tweetFromJson(res['body']);
    } catch (e) {
      if (e is DioError) {
        throw FlutterError(e.toString());
      }
      Get.snackbar(
        "error",
        e.toString(),
        backgroundColor: Colors.white,
      );
    }
  }

  Future<void> tweet(String text, String url, String photo) async {
    if (photo == null) {
      await network.postCall(url, {'content': text});
    } else {
      await network.postCall(url, {'content': text, 'photo': photo});
    }
  }

  Future<void> like(String url) async {
    try {
      var res = await network.putCall(url);
      SocketHandler.socket.emit('like', res['body']);
    } catch (e) {
      if (e is DioError) {
      } else
        Get.snackbar(
          "error",
          e.toString(),
          backgroundColor: Colors.white,
        );
    }
  }

  Future<void> retweet(String url) async {
    try {
      var res = await network.putCall(url);

      SocketHandler.socket.emit('retweet', res['body']);
    } catch (e) {
      if (e is DioError) {
      } else
        Get.snackbar(
          "error",
          e.toString(),
          backgroundColor: Colors.white,
        );
    }
  }

  // ignore: missing_return
  Future<Reply> reply(String url, String reply) async {
    try {
      var res = await network.putCall(url, data: {'reply': reply});

      return Reply.fromJson(res['body']);
    } on Exception catch (e) {
      print(e);
    }
  }

  // ignore: missing_return
  Future<Tweet> getSinglePost(String url) async {
    try {
      var res = await network.getCall(url);
      return Tweet.fromJson(res['body']);
    } catch (e) {
      if (e is DioError) {
        Get.snackbar(
          'error',
          "something went wrong please chek you internet connection",
          backgroundColor: Colors.white,
        );
        return null;
      }
      Get.snackbar(
        "error",
        e.toString(),
        backgroundColor: Colors.white,
      );
    }
  }

  // ignore: missing_return
  Future<List<Tweet>> getUserPosts(String url) async {
    try {
      var res = await network.getCall(url);
      return tweetFromJson(res['body']);
    } catch (e) {
      if (e is DioError) {
        Get.snackbar(
          'error',
          "something went wrong please chek you internet connection",
          backgroundColor: Colors.white,
        );
        return null;
      }
      Get.snackbar(
        "error",
        e.toString(),
        backgroundColor: Colors.white,
      );
    }
  }

  // ignore: missing_return
  Future<List<Tweet>> searchPost(String url) async {
    try {
      var res = await network.getCall(url);
      if (res['code'] == 200) {
        var tweets = tweetFromJson(res['body']);
        return tweets;
      } else
        Get.snackbar("error", res['body']['error'].toString(),
            backgroundColor: Colors.white);

      return null;
    } catch (e) {
      if (e is DioError) {
        Get.snackbar(
          'error',
          "something went wrong please chek you internet connection",
          backgroundColor: Colors.white,
        );
        return null;
      }
      Get.snackbar(
        "error",
        e.toString(),
        backgroundColor: Colors.white,
      );
    }
  }
}
