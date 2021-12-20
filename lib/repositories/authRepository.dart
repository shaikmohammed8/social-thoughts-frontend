import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/controller/mainController.dart';
import 'package:twitter_clone/services/Cachhandler.dart';
import 'package:twitter_clone/services/NetworkHandler.dart';

class AuthRepository {
  var controller = Get.find<MainController>();
  Future<void> login(String email, String password) async {
    try {
      var res = await NetworkHandler()
          .authCall("user/login", {"email": email, "password": password});
      if (res['code'] == 200) {
        var body = res['body'];
        CacheHandler.writeCache("jwt", body['token']);
        CacheHandler.writeCache("id", body['user']['_id']);
        CacheHandler.writeCache('name', body['user']['name']);
        CacheHandler.writeCache('profilePic', body['user']['profilePic']);
        controller.auth();
      } else {
        Get.snackbar("error", res['body']['error'].toString(),
            backgroundColor: Colors.white);
      }
    } catch (e) {
      if (e is DioError) {
        return Get.snackbar(
          'error',
          "something went wrong please chek you internet connection",
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
}

class SignupReposiory {
  var controller = Get.find<MainController>();

  singup(String email, String password, String username) async {
    try {
      var res = await NetworkHandler().authCall("user/register", {
        "email": email,
        "password": password,
        "name": username,
        "username": username
      });
      if (res['code'] == 201) {
        var body = res['body'];
        CacheHandler.writeCache("jwt", body['token']);
        CacheHandler.writeCache("id", body['user']['_id']);
        CacheHandler.writeCache('name', body['user']['name']);
        CacheHandler.writeCache('profilePic', body['user']['profilePic']);
        controller.auth();
      } else {
        Get.snackbar("error", res['body']['error'].toString(),
            backgroundColor: Colors.white);
      }
    } catch (e) {
      if (e is DioError) {
        return Get.snackbar(
          'error',
          "something went wrong please chek you internet connection",
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
}
