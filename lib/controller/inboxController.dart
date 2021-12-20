import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/controller/mainController.dart';

import '../models/chat.dart';
import '../repositories/chatRepository.dart';
import '../services/socket.io.dart';

class InboxController extends GetxController {
  var chatRepo = ChatRepository();
  RxList<Chat> chats = RxList.empty();
  var controller = Get.find<MainController>();
  int i = 0;
  var isGroupchat = false;
  RxBool waiting = RxBool(true);
  ScrollController sController = ScrollController();

  chekUnread() {
    if (isGroupchat) {
      chats.stream.listen((event) async {
        await Future.delayed(Duration(seconds: 1));

        var useen = event
            .where((element) => !element.seenBy.contains(controller.id.value));
        controller.useenMessages.value = useen.length;
      });
    } else {
      chats.stream.listen((event) async {
        await Future.delayed(Duration(seconds: 1));

        var useen = event
            .where((element) => !element.seenBy.contains(controller.id.value));
        controller.useenMessages.value = useen.length;
      });
    }
  }

  addListner(String url) {
    SocketHandler.socket.on('chat:update', (data) {
      log('chat:update');
      Chat chat = Chat.fromJson(data['chat']);

      if (data['operation'] == 'update') {
        for (i = 0; i < chats.length; i++) {
          var chat = chats[i];

          if (chat.id == data['chat']['_id']) {
            var t = Chat.fromJson(data['chat']);
            chats[i] = t;
          }
        }
      } else if (data['operation'] == 'insert') {
        chats.insert(0, chat);
      } else if (data['operation'] == 'delete') {}
    });
    sController.addListener(() async {
      if (sController.position.pixels == sController.position.maxScrollExtent) {
        waiting.value = true;
        if (waiting.value) {
          var list = await chatRepo.getChats(url + 'skip=${chats.length}');

          chats.addAll(list);
          waiting.value = false;
        }
      }
    });
    super.onInit();
  }
}
