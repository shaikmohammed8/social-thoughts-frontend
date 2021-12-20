import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/controller/ChatController.dart';
import 'package:twitter_clone/controller/likecontroller.dart';
import 'package:twitter_clone/screens/chatscreen/chatScreen.dart';
import 'package:twitter_clone/screens/homescreen.dart';
import 'package:twitter_clone/screens/inboxscreen.dart';
import 'package:twitter_clone/screens/profilescreen/profilescreeen.dart';
import 'package:twitter_clone/screens/searchScreen.dart';
import 'package:twitter_clone/screens/tweetscreen/tweetscreen.dart';
import 'package:twitter_clone/services/socket.io.dart';
import 'package:twitter_clone/utils/decider.dart';
import 'package:twitter_clone/utils/theme.dart';

import 'controller/FollowController.dart';
import 'controller/messageController.dart';
import 'screens/messagescreen/messagescreen.dart';

void main() {
  SocketHandler();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Social thoughts',
      smartManagement: SmartManagement.full,
      getPages: [
        GetPage(
            name: 'profile',
            page: () => ProfileScreen(),
            binding: ProfileBinding()),
        GetPage(
            name: 'tweetscreen',
            page: () => TweetScreen(),
            binding: LikeBinding()),
        GetPage(
            name: 'chatscreen',
            page: () => ChatScreen(),
            binding: ChatBinding()),
        GetPage(
            name: 'messagescreen',
            page: () => MessageScreen(),
            binding: MessageBinding()),
        GetPage(
            name: 'homescreen',
            page: () => HomeScreen(),
            binding: ChatBinding()),
        GetPage(name: 'searchscreen', page: () => SearchScreen()),
        GetPage(name: 'notificationscreen', page: () => Container()),
        GetPage(
          name: 'inboxscreen',
          page: () => InboxScreen(),
        )
      ],
      theme: Themes.light,
      home: Decider(),
    );
  }
}
