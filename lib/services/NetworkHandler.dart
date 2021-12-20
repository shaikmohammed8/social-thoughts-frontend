import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/screens/landignscreen.dart';
import 'package:twitter_clone/services/Cachhandler.dart';

class NetworkHandler {
  var dio = Dio(BaseOptions(
    followRedirects: false,
    validateStatus: (s) => s <= 500,
  ));
  String baseurl = "Enter you base url";
  Map<String, dynamic> header = {
    'Accept': "application/json",
    'Content-Type': "application/json;charset=UTF-8",
  };

  Future<Map> postCall(
    String apiUrl,
    Map body,
  ) async {
    var url = Uri.parse(baseurl + apiUrl);
    var json = jsonEncode(body);
    var jwt = await CacheHandler.readCache('jwt');
    header.addAll({'Authorization': jwt});
    var res = await dio.post(url.toString(),
        options: Options(headers: header), data: json);
    if (res.statusCode < 200 || res.statusCode > 300) {
      if (res.data['error'] == 'please sing in') {
        await CacheHandler.deleteCache();
        Get.offAll(LandingScreen());
      }
    }
    return {"body": res.data, "code": res.statusCode};
  }

  Future<Map> authCall(
    String apiUrl,
    Map body,
  ) async {
    var url = Uri.parse(baseurl + apiUrl);
    var json = jsonEncode(body);
    var res = await dio.post(url.toString(),
        options: Options(headers: header), data: json);
    if (res.statusCode < 200 || res.statusCode > 300) {
      if (res.data['error'] == 'please sing in') {
        await CacheHandler.deleteCache();
        Get.offAll(LandingScreen());
      }
    }
    return {"body": res.data, "code": res.statusCode};
  }

  Future<Map> getCall(String apiUrl) async {
    var url = Uri.parse(baseurl + apiUrl);
    var jwt = await CacheHandler.readCache('jwt');
    header.addAll({'Authorization': jwt});
    await Future.delayed(Duration(milliseconds: 1000));
    var res = await dio.get(url.toString(),
        options: Options(headers: header, validateStatus: (s) => s <= 500));
    if (res.statusCode < 200 || res.statusCode > 300) {
      if (res.data['error'] == 'please sing in') {
        await CacheHandler.deleteCache();
        Get.offAll(LandingScreen());
      }
      throw FlutterError(res.data['error'] ?? "something whent wrong");
    }
    return {"body": res.data, "code": res.statusCode};
  }

  Future<Map> putCall(String apiUrl, {Map data}) async {
    var url = Uri.parse(baseurl + apiUrl);
    var jwt = await CacheHandler.readCache('jwt');
    header.addAll({'Authorization': jwt});
    var res = await dio.put(
      url.toString(),
      options: Options(headers: header, validateStatus: (s) => s <= 500),
      data: data,
    );
    if (res.statusCode < 200 || res.statusCode > 300) {
      if (res.data['error'] == 'please sing in') {
        await CacheHandler.deleteCache();
        Get.offAll(LandingScreen());
      }
    }
    return {"body": res.data, "code": res.statusCode};
  }

  Future getttCall(String apiUrl) async {
    var url = Uri.parse(baseurl + apiUrl);
    var jwt = await CacheHandler.readCache('jwt');
    header.addAll({'Authorization': jwt});
    await Future.delayed(Duration(milliseconds: 1000));
    var res = await dio.get(url.toString(), options: Options(headers: header));
    if (res.statusCode < 200 || res.statusCode > 300) {
      if (res.data['error'] == 'please sing in') {
        Get.offAll(LandingScreen());
      }
    }
    return {"body": res.data, "code": res.statusCode};
  }
}
