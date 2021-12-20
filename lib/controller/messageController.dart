import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/controller/inboxController.dart';
import 'package:twitter_clone/controller/mainController.dart';
import 'package:twitter_clone/services/socket.io.dart';

import '../models/message.dart';
import '../repositories/chatRepository.dart';

class MessageController extends GetxController {
  var messageRepo = ChatRepository();
  RxString url = RxString(null);
  String otherUserId;
  String chatId;
  String conversationId;
  RxBool waiting = RxBool(false);
  var controller = Get.find<MainController>();
  // ignore: non_constant_identifier_names
  var Listkey = GlobalKey<AnimatedListState>();
  RxList<Message> messages = <Message>[].obs;
  ScrollController sController = ScrollController();

  onClose() {
    dispose();
    super.onClose();
  }

  dispose() {
    url = RxString(null);
    otherUserId = null;
    chatId = null;
    conversationId = null;
    SocketHandler.socket.off('message:update');
    controller = null;
    Listkey = null;
    messages = <Message>[].obs;
    sController.dispose();
    super.dispose();
  }

  onInit() {
    SocketHandler.socket.on('message:update', (data) {
      if (chatId != null) {
        conversationId = chatId;
      } else if (otherUserId != null) {
        conversationId = Get.find<InboxController>(tag: 'private')
            .chats
            .firstWhere((element) {
          var user = element.users
              .firstWhere((user) => user.id == otherUserId, orElse: () => null);
          return user != null;
        }).id;
      }

      if (data['message']['chat'] != conversationId) {
        return;
      } else {
        socketFunction(data, conversationId);
      }
    });

    sController.addListener(() async {
      if (sController.position.pixels == sController.position.maxScrollExtent) {
        waiting.value = true;
        var indexxx = messages.length - 1;
        var list = await messageRepo.getMessage("$url?skip=${messages.length}");
        log(messages.toString());
        messages.addAll(list);
        for (var i = 0; i < list.length; i++) {
          if (Listkey.currentState != null) {
            Listkey.currentState
                .insertItem(indexxx + i, duration: Duration(milliseconds: 0));
          }
        }

        waiting.value = false;
      }
    });
    super.onInit();
  }

  socketFunction(Map data, String thisChatId) {
    if (data['operation'] == 'update') {
      for (var i = 0; i < messages.length; i++) {
        var message = messages[i];

        if (message.id == data['message']['_id']) {
          var t = Message.fromJson(data['message']);
          messages[i] = t;
        }
      }
    } else if (data['operation'] == 'insert') {
      if (data['message']['uuid'] == null) {
        var t = Message.fromJson(data['message']);
        if (Listkey.currentState != null) {
          Listkey.currentState
              .insertItem(0, duration: Duration(milliseconds: 200));
        }
        messages.insert(0, t);

        if (thisChatId != null) {
          log(thisChatId);
          ChatRepository().seenMessage('api/chat/seen?chatId=$thisChatId');
        }
        return null;
      }
      for (var i = 0; i < messages.length; i++) {
        var message = messages[i];

        if (message.uuid == data['message']['uuid']) {
          var t = Message.fromJson(data['message']);
          return messages[i] = t;
        }
      }
      if (Listkey.currentState != null) {
        Listkey.currentState
            .insertItem(0, duration: Duration(milliseconds: 200));
      }
      messages.insert(0, Message.fromJson(data['message']));
      if (thisChatId != null) {
        ChatRepository().seenMessage('api/chat/seen?chatId=$thisChatId');
      }
    } else if (data['operation'] == 'delete') {
      messages.removeWhere((element) => element.id == data['documentId']);
    }
  }

  playMessageSound() {
    SystemSound.play(SystemSoundType.alert);
  }
}

class MessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageController());
  }
}
