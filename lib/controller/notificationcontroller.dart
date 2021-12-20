import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/models/notification.dart';
import 'package:twitter_clone/repositories/userRapository.dart';
import 'package:twitter_clone/services/socket.io.dart';

class NotificationController extends GetxController {
  var userRepo = UserReposiotry();
  RxList<Notifications> notifications = <Notifications>[].obs;

  RxBool waiting = RxBool(true);
  ScrollController sController = ScrollController();
  onInit() {
    SocketHandler.socket.on('notification:update', (data) {
      Notifications notifi = Notifications.fromJson(data['notification']);
      print("asdfasdf" + notifi.id);
      if (data['operation'] == 'update') {
        for (var i = 0; i < notifications.length; i++) {
          var chat = notifications[i];

          if (chat.id == data['notification']['_id']) {
            var t = Notifications.fromJson(data['notification']);

            notifications[i] = t;

            return;
          }
        }
        notifications.insert(0, notifi);
      } else if (data['operation'] == 'insert') {
        notifications.insert(0, notifi);
      } else if (data['operation'] == 'delete') {}
    });
    sController.addListener(() async {
      if (sController.position.pixels == sController.position.maxScrollExtent) {
        waiting.value = true;
        var list = await UserReposiotry()
            .getNotifications('api/notification?skip=${notifications.length}');

        notifications.addAll(list);
        waiting.value = false;
      }
    });
    super.onInit();
  }
}
