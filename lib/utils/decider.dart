import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/controller/mainController.dart';
import 'package:twitter_clone/screens/bottomnavigation.dart';
import 'package:twitter_clone/screens/landignscreen.dart';
import 'package:twitter_clone/screens/splashscreen.dart';
import 'package:twitter_clone/services/Cachhandler.dart';
import 'package:twitter_clone/services/socket.io.dart';

// ignore: must_be_immutable
class Decider extends StatelessWidget {
  var controller = Get.put(MainController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        CacheHandler.readCache('id'),
        CacheHandler.readCache("jwt"),
        Future.delayed(Duration(seconds: 1))
      ]),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return AnimatedSwitcher(
            duration: Duration(milliseconds: 1500),
            transitionBuilder: (widget, animation) {
              return FadeTransition(
                opacity: animation,
                child: widget,
              );
            },
            child: snapshot.connectionState == ConnectionState.waiting
                ? SplashScreen(key: Key('s'))
                : snapshot.data[0] != null && snapshot.data[1] != null
                    ? bottomNavScreen(snapshot)
                    : LandingScreen(key: Key('l')));
      },
    );
  }

  BottomNavigation bottomNavScreen(snapshot) {
    controller.id.value = snapshot.data[0];
    controller.jwt.value = snapshot.data[1];

    SocketHandler.socket.emit('join', controller.id.value);
    return BottomNavigation(key: Key('b'));
  }
}
