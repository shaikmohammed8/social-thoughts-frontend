import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:twitter_clone/models/chat.dart';
import 'package:twitter_clone/repositories/chatRepository.dart';
import 'package:twitter_clone/utils/utlis.dart';
import 'package:twitter_clone/widgets/drawer.dart';
import 'package:twitter_clone/widgets/shimmer.dart';

import '../controller/inboxController.dart';
import '../controller/mainController.dart';
import 'bottomnavigation.dart';

// ignore: must_be_immutable
class InboxScreen extends StatelessWidget {
  final chatRepo = ChatRepository();

  var scaffoldKey = GlobalKey<ScaffoldState>();
  InboxScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldKey,
        drawer: CustomDrawer(),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.sort,
              color: Colors.white,
            ),
            onPressed: () {
              scaffoldKey.currentState.openDrawer();
            },
          ),
          title: Text(
            'Inbox',
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Iconsax.add_square,
                color: Colors.white,
              ),
              onPressed: () {
                Get.toNamed('chatscreen');
              },
            )
          ],
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(3),
            onTap: (index) {},
            indicatorWeight: 3,
            indicatorColor: Colors.white54,
            tabs: [
              Tab(
                child: Text(
                  "    Messages    ",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: Colors.white),
                ),
              ),
              Tab(
                child: Text('      Groups      ',
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
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: TabBarView(
              children: [
                chatWidget(
                  indexx: 1,
                  future: chatRepo.getChats("api/chat?isGroup=false&skip=0"),
                  inboxController: Get.put(InboxController(), tag: "private"),
                  url: "api/chat?isGroup=false&skip=0",
                ),
                chatWidget(
                  url: 'api/chat?isGroup=true&skip=0',
                  indexx: 2,
                  future: chatRepo.getChats("api/chat?isGroup=true&skip=0"),
                  inboxController: Get.put(InboxController(), tag: "group"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class chatWidget extends GetView<MainController> {
  chatWidget({
    this.url,
    this.inboxController,
    this.indexx,
    Key key,
    @required this.future,
  });
  final url;
  final indexx;
  final Future<List<Chat>> future;
  final InboxController inboxController;

  @override
  Widget build(BuildContext context) {
    inboxController.addListner(url);
    return FutureBuilder<List<Chat>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ShimmerAnimation(
            isChat: true,
          );
        }
        {
          if (snapshot.hasData) {
            inboxController.isGroupchat = indexx == 1 ? false : true;
            inboxController.chekUnread();
            inboxController.chats.value = snapshot.data;
            print(controller.unseenGroupMessage);
          } else if (snapshot.hasError) {
            print("eroor              asdf");
            return error(
              context,
              () {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (a, b, c) => BottomNavigation(indexx: 3)));
              },
            );
          }
          return Obx(
            () => inboxController.chats.length == 0
                ? noData(context)
                : ListView.builder(
                    itemCount: inboxController.chats.length,
                    itemBuilder: (context, index) {
                      if (indexx == 1) {
                        if (inboxController.chats[index].isGroupChat)
                          return SizedBox();
                      } else {
                        if (!inboxController.chats[index].isGroupChat)
                          return SizedBox();
                      }
                      return ListTile(
                        onTap: () => Get.toNamed('messagescreen',
                            arguments: inboxController.chats[index].isGroupChat
                                ? {
                                    "id": inboxController.chats[index].id,
                                    'name':
                                        inboxController.chats[index].chatName,
                                    'photo': inboxController.chats[index].photo,
                                    'isGroup':
                                        inboxController.chats[index].isGroupChat
                                  }
                                : {
                                    'isGroup': inboxController
                                        .chats[index].isGroupChat,
                                    "id": inboxController.chats[index].users
                                        .where((element) =>
                                            element.id != controller.id.value)
                                        .first
                                        .id,
                                    'name': inboxController.chats[index].users
                                        .where((element) =>
                                            element.id != controller.id.value)
                                        .first
                                        .name,
                                    'photo': inboxController.chats[index].users
                                        .where((element) =>
                                            element.id != controller.id.value)
                                        .first
                                        .profilePic
                                  }),
                        leading: GestureDetector(
                          onTap: () => inboxController.chats[index].isGroupChat
                              ? null
                              : Get.toNamed('profile',
                                  arguments: inboxController.chats[index].users
                                      .where((element) =>
                                          element.id != controller.id.value)
                                      .first
                                      .id),
                          child: Container(
                            height: 45,
                            width: 45,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(17),
                                child: inboxController.chats[index].isGroupChat
                                    ? image(inboxController.chats[index].photo)
                                    : image(inboxController.chats[index].users
                                        .where((element) =>
                                            element.id != controller.id.value)
                                        .first
                                        .profilePic)),
                          ),
                        ),
                        title: inboxController.chats[index].isGroupChat
                            ? Text(
                                inboxController.chats[index].chatName
                                    .toString(),
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.caption)
                            : Text(
                                inboxController.chats[index].users
                                    .where((element) =>
                                        element.id != controller.id.value)
                                    .first
                                    .name
                                    .toString(),
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.caption),
                        subtitle: inboxController.chats[index].lastMessage ==
                                null
                            ? Text("no new message here",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.overline)
                            : inboxController
                                        .chats[index].lastMessage.message ==
                                    null
                                ? Wrap(
                                    children: [
                                      Icon(
                                        Icons.image,
                                        color: Colors.grey[400],
                                      ),
                                    ],
                                  )
                                : Text(
                                    inboxController
                                        .chats[index].lastMessage.message
                                        .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: inboxController.chats[index].seenBy
                                            .contains(controller.id.value)
                                        ? Theme.of(context).textTheme.overline
                                        : Theme.of(context)
                                            .textTheme
                                            .overline
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                        trailing: inboxController.chats[index].lastMessage ==
                                null
                            ? SizedBox()
                            : inboxController.chats[index].seenBy
                                    .contains(controller.id.value)
                                ? Text(
                                    DateFormat('hh mm')
                                        .format(inboxController
                                            .chats[index].lastMessage.updatedAt)
                                        .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.overline)
                                : CircleAvatar(
                                    radius: 6,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                  ),
                      );
                    }),
          );
        }
      },
    );
  }

  Container noData(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.subtitles_off_rounded,
                size: 150,
                color: Theme.of(context).dividerColor,
              ),
              Text(
                "You dont have any conversation yet",
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: Theme.of(context).dividerColor),
              ),
            ],
          ),
        ));
  }
}
