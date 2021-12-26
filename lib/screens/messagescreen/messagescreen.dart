import 'dart:math';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:twitter_clone/controller/inboxController.dart';
import 'package:twitter_clone/controller/mainController.dart';
import 'package:twitter_clone/models/message.dart';
import 'package:twitter_clone/repositories/chatRepository.dart';
import 'package:twitter_clone/screens/messagescreen/widget/messagewidget.dart';
import '../../credeantials/cloudainary.dart' as cd;
import 'package:twitter_clone/utils/utlis.dart';

import '../../controller/mainController.dart';
import '../../controller/messageController.dart';
import '../../models/message.dart';
import '../../repositories/chatRepository.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class MessageScreen extends GetView<MessageController> {
  var uuid = Uuid();
  var textcontroller = TextEditingController();
  var mainController = Get.find<MainController>();
  var messgaeRepo = ChatRepository();
  ImagePicker imagePicker = ImagePicker();

  var cloud = Cloudinary(
      cd.Cloudinary.API_KEY, cd.Cloudinary.API_SECRET, cd.Cloudinary.API_ENV);

  @override
  Widget build(BuildContext context) {
    if (args(context)['isGroup']) {
      controller.chatId = args(context)['id'];
      messgaeRepo.seenMessage('api/chat/seen?chatId=${args(context)['id']}');
    } else {
      controller.otherUserId = args(context)['id'];

      messgaeRepo.seenMessage('api/chat/seen?userId=${args(context)['id']}');
    }
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                  height: 30,
                  width: 30,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: image(args(context)['photo']))),
              SizedBox(
                width: 8,
              ),
              Flexible(
                child: Text(args(context)['name'],
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: Colors.white)),
              )
            ],
          ),
        ),
        body: Container(
          color: Theme.of(context).primaryColor,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: args(context)['isGroup']
                ? messageFuture(
                    messgaeRepo.getMessage(
                        "api/message/${args(context)['id']}/groupMessages?skip=0"),
                    "api/message/${args(context)['id']}/groupMessages")
                : messageFuture(
                    messgaeRepo.getMessage(
                        "api/message/${args(context)['id']}/messages?skip=0"),
                    "api/message/${args(context)['id']}/messages"),
          ),
        ),
        bottomSheet: Container(
            height: 60,
            padding: EdgeInsets.all(8),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                    icon: Icon(
                      Iconsax.gallery,
                      size: 24,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => sendImage(context)),
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: Theme.of(context).dividerColor,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: textcontroller,
                      style: Theme.of(context).textTheme.caption,
                      textAlignVertical: TextAlignVertical.center,
                      maxLength: 1000,
                      minLines: 1,
                      maxLines: 2,
                      decoration: InputDecoration(
                        isDense: true,
                        counterText: '',
                        hintText: 'Type something here',
                      ),
                    ),
                  ),
                ),
                ValueListenableBuilder<TextEditingValue>(
                    valueListenable: textcontroller,
                    builder: (context, value, child) {
                      return IconButton(
                        color: Theme.of(context).primaryColor,
                        icon: Icon(
                          Iconsax.send_1,
                        ),
                        onPressed: value.text.trim().isEmpty
                            ? null
                            : () {
                                var uniqueid = uuid.v1();
                                if (controller.Listkey.currentState != null) {
                                  controller.Listkey.currentState.insertItem(0,
                                      duration: Duration(milliseconds: 200));
                                }
                                var message = Message(
                                    uuid: uniqueid,
                                    updatedAt: DateTime.now(),
                                    sender: Sender(id: mainController.id.value),
                                    id: Random().nextInt(6).toString(),
                                    message: value.text.trim());
                                controller.messages.insert(0, message);
                                getChatId(context, message);
                                messgaeRepo.uploadMessage(
                                    Message(
                                        message: value.text.trim(),
                                        uuid: uniqueid),
                                    args(context)['isGroup']
                                        ? "api/message?chatId=${args(context)['id']}"
                                        : "api/message?id=${args(context)['id']}");
                                textcontroller.clear();
                              },
                      );
                    })
              ],
            )));
  }

  FutureBuilder<List<dynamic>> messageFuture(Future future, String url) {
    return FutureBuilder<List<dynamic>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                padding: EdgeInsets.only(top: 200),
                alignment: Alignment.topCenter,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ));
          } else {
            if (snapshot.hasData) {
              controller.messages.value = snapshot.data;
            }
            controller.url.value = url;
            return Obx(() {
              return controller.messages.length == 0
                  ? Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.subtitles_off_rounded,
                            size: 50,
                            color: Colors.grey[300],
                          ),
                          Text(
                            "You dont have any conversation yet",
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(color: Colors.grey[350]),
                          ),
                        ],
                      ))
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: Column(
                        children: [
                          controller.waiting.value
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : SizedBox(),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AnimatedList(
                                  key: controller.Listkey,
                                  reverse: true,
                                  controller: controller.sController,
                                  shrinkWrap: true,
                                  initialItemCount: controller.messages.length,
                                  itemBuilder: (context, index, animation) {
                                    Widget child;
                                    if (index !=
                                        controller.messages.length - 1) {
                                      if (controller
                                              .messages[index].updatedAt.day !=
                                          controller.messages[index + 1]
                                              .updatedAt.day) {
                                        child = Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            DateFormat('dd MMM yyyy').format(
                                                controller
                                                    .messages[index].updatedAt),
                                            style: Theme.of(context)
                                                .textTheme
                                                .overline
                                                .copyWith(
                                                    fontSize: 12,
                                                    color: Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(0.4)),
                                          ),
                                        );
                                      }
                                    } else {
                                      child = Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          DateFormat('dd MMM yyyy').format(
                                              controller
                                                  .messages[index].updatedAt),
                                          style: Theme.of(context)
                                              .textTheme
                                              .overline
                                              .copyWith(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.4)),
                                        ),
                                      );
                                    }
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 1),
                                        end: Offset(0, 0),
                                      ).animate(animation),
                                      child: Column(
                                        children: [
                                          child == null ? SizedBox() : child,
                                          MessageWidget(
                                            perviousMessage: index == 0
                                                ? null
                                                : controller.messages[index - 1]
                                                    .sender.id,
                                            previousTime: index == 0
                                                ? DateTime(2020, 1, 1)
                                                : controller.messages[index - 1]
                                                    .updatedAt,
                                            message: controller
                                                .messages[index].message,
                                            cUid: mainController.id.value,
                                            isGroupChat:
                                                args(context)['isGroup'],
                                            id: controller.messages[index].id,
                                            photoUrl: controller
                                                .messages[index].photo,
                                            time: controller
                                                .messages[index].updatedAt,
                                            sId: controller
                                                .messages[index].sender.id,
                                            sName: controller
                                                .messages[index].sender.name,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    );
            });
          }
        });
  }

  Map args(context) {
    return ModalRoute.of(context).settings.arguments;
  }

  sendImage(context) async {
    try {
      var image = await imagePicker.pickImage(
          source: ImageSource.gallery, maxHeight: 400, maxWidth: 600);
      if (image != null) {
        var uniqueid = uuid.v1();
        if (controller.Listkey.currentState != null) {
          controller.Listkey.currentState
              .insertItem(0, duration: Duration(milliseconds: 200));
        }
        var message = Message(
            uuid: uniqueid,
            updatedAt: DateTime.now(),
            sender: Sender(id: mainController.id.value),
            id: Random().nextInt(6).toString(),
            photo: 'nophoto');
        controller.messages.insert(0, message);
        getChatId(context, message);
        print("asdfasdfasdf");
        var upload =
            await cloud.uploadFile(filePath: image.path, folder: 'messages');
        print("asdfasdfasdfaaaaaaaaaaa");
        if (upload.error == null) {
          messgaeRepo.uploadMessage(
              Message(uuid: uniqueid, photo: upload.url),
              args(context)['isGroup']
                  ? "api/message?chatId=${args(context)['id']}"
                  : "api/message?id=${args(context)['id']}");
        }
      }
    } catch (e) {
      Get.snackbar(
        'error',
        e,
        backgroundColor: Colors.white,
      );
    }
  }

  getChatId(context, Message meesage) {
    print(args(context)['isGroup']);
    if (args(context)['isGroup']) {
      Get.find<InboxController>(tag: 'group').chats.forEach((ele) {
        print(ele);
        if (ele.id == args(context)['id']) {
          ele.lastMessage = meesage;
          return;
        }
      });
      Get.find<InboxController>(tag: 'group').chats.refresh();
    } else {
      print(args(context)['isGroup']);
      Get.find<InboxController>(tag: 'private').chats.forEach((element) {
        var user = element.users.firstWhere(
            (element) => element.id == args(context)['id'],
            orElse: () => null);
        if (user != null) {
          print(element.lastMessage);
          element.lastMessage = meesage;
          return;
        }
      });
      Get.find<InboxController>(tag: 'private').chats.refresh();
    }
  }
}
