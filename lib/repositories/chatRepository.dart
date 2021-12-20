import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/models/chat.dart';
import 'package:twitter_clone/models/message.dart';
import 'package:twitter_clone/services/NetworkHandler.dart';

class ChatRepository {
  var network = NetworkHandler();
  chat(Chat chat, String url) async {
    try {
      var res = await network.postCall(url, chat.toJson());
      if (res['code'] == 200) {
        Get.back();
        Get.back();
      }
    } catch (e) {
      if (e is DioError) {
        return null;
      }
      Get.snackbar(
        "error",
        e.toString(),
        backgroundColor: Colors.white,
      );
    }
  }

  Future<List<Chat>> getChats(String url) async {
    try {
      var res = await network.getCall(url);
      return List<Chat>.from(res['body'].map((x) => Chat.fromJson(x)));
    } catch (e) {
      if (e is DioError) {
        throw FlutterError('something went wrong');
      }
      Get.snackbar(
        "error",
        e.toString(),
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  oneChat(Map map, String url) async {
    try {
      var res = await network.postCall(url, map);
      if (res['code'] == 200) {
        Get.back();
      }
    } catch (e) {
      if (e is DioError) {
        return null;
      }
      Get.snackbar(
        "error",
        e.toString(),
        backgroundColor: Colors.white,
      );
    }
  }

  uploadMessage(Message message, String url) async {
    try {
      var res = await network.postCall(url, message.toJson());
      if (res['code'] == 200) {}
    } catch (e) {
      if (e is DioError) {
        return Get.snackbar(
          'error',
          "please check your internet connection send this message again",
          backgroundColor: Colors.white,
        );
      }
      Get.snackbar(
        "error",
        e.toString(),
        backgroundColor: Colors.white,
      );
    }
  }

  // ignore: missing_return
  Future<List<Message>> getMessage(String url) async {
    try {
      var res = await network.getCall(url);
      if (res['code'] == 200) {
        return messageFromJson(res['body']);
      }
    } catch (e) {
      if (e is DioError) {
        Get.snackbar(
          "error",
          "something went wrong please check you internet connection",
          backgroundColor: Colors.white,
        );
        return null;
      }
      Get.snackbar(
        "error",
        e.toString(),
        backgroundColor: Colors.white,
      );

      return null;
    }
  }

  seenMessage(String url) async {
    try {
      var res = await network.putCall(url);
      if (res['code'] == 200) {}
    } catch (e) {
      if (e is DioError) {
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
