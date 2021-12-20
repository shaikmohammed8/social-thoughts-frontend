import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/screens/bottomnavigation.dart';
import 'package:twitter_clone/screens/landignscreen.dart';
import 'package:twitter_clone/services/Cachhandler.dart';
import 'package:twitter_clone/services/socket.io.dart';

class MainController extends GetxController {
  var tabName = "user";
  var useenMessages = 0.obs;
  var unseenGroupMessage = 0.obs;
  var isWaiting = false.obs;
  final id = RxString(null);
  final jwt = RxString(null);
  final name = RxString(null);
  final profilePic = RxString(null);

  final password = 'none'.obs;

  var postTextController = TextEditingController();
  var img = ''.obs;
  chaneTab(String tab) {
    tabName = tab;
    update();
  }

  @override
  Future<void> onInit() async {
    id.value = await CacheHandler.readCache('id');
    jwt.value = await CacheHandler.readCache('jwt');
    name.value = await CacheHandler.readCache('name');
    profilePic.value = await CacheHandler.readCache('profilePic');

    super.onInit();
  }

  logout() async {
    id.value = null;
    jwt.value = null;

    name.value = null;
    profilePic.value = null;
    await CacheHandler.deleteCache();
    Get.offAll(() => LandingScreen());
  }

  auth() async {
    id.value = await CacheHandler.readCache('id');
    jwt.value = await CacheHandler.readCache('jwt');
    name.value = await CacheHandler.readCache('name');
    profilePic.value = await CacheHandler.readCache('profilePic');

    SocketHandler.socket.emit('join', await CacheHandler.readCache('id'));
    Get.offAll(() => BottomNavigation());
  }
}
