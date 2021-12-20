import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:twitter_clone/controller/mainController.dart';
import 'package:twitter_clone/controller/notificationcontroller.dart';
import 'package:twitter_clone/models/notification.dart';
import 'package:twitter_clone/repositories/userRapository.dart';
import 'package:twitter_clone/utils/utlis.dart';
import 'package:twitter_clone/widgets/drawer.dart';

import '../bottomnavigation.dart';

// ignore: must_be_immutable
class NotificationScreen extends GetView<MainController> {
  var nController = Get.put(NotificationController());
  NotificationScreen({Key key}) : super(key: key);
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        drawer: CustomDrawer(),
        appBar: AppBar(
          title: Text(
            'Notification',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.sort,
              color: Colors.white,
            ),
            onPressed: () {
              scaffoldKey.currentState.openDrawer();
            },
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
                child: FutureBuilder<List<Notifications>>(
                  future: UserReposiotry()
                      .getNotifications('api/notification?skip=0'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      print(snapshot.data.length);
                      nController.notifications.value = snapshot.data;
                    } else if (snapshot.hasError) {
                      return error(
                        context,
                        () {
                          Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (a, b, c) => BottomNavigation(
                                        indexx: 2,
                                      )));
                        },
                      );
                    }

                    return Obx(() => nController.notifications.length > 0
                        ? ListView.builder(
                            padding: EdgeInsets.only(top: 10, bottom: 60),
                            itemCount: nController.notifications.length,
                            itemBuilder: (context, index) {
                              Widget child;
                              if (index != 0) {
                                if (nController
                                        .notifications[index].updatedAt.day !=
                                    nController.notifications[index - 1]
                                        .updatedAt.day) {
                                  child = Text(
                                    isToday(nController
                                            .notifications[index].updatedAt)
                                        ? "Today"
                                        : DateFormat('dd MMM yyyy').format(
                                            nController.notifications[index]
                                                .updatedAt),
                                    style: Theme.of(context).textTheme.overline,
                                  );
                                }
                              } else {
                                child = Text(
                                  isToday(nController
                                          .notifications[index].updatedAt)
                                      ? "Today"
                                      : DateFormat('dd MMM yyyy').format(
                                          nController
                                              .notifications[index].updatedAt),
                                  style: Theme.of(context).textTheme.overline,
                                );
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  child == null
                                      ? SizedBox()
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: child,
                                        ),
                                  ListTile(
                                      onTap: () {
                                        if (nController
                                                .notifications[index].type ==
                                            "follow") {
                                          Get.toNamed('profile',
                                              arguments: nController
                                                  .notifications[index]
                                                  .contentId);
                                        } else
                                          Get.toNamed('tweetscreen',
                                              arguments: nController
                                                  .notifications[index]
                                                  .contentId);
                                      },
                                      subtitle: nController
                                                  .notifications[index].photo ==
                                              null
                                          ? SizedBox()
                                          : Container(
                                              height: 100,
                                              width: 30,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Image.network(
                                                  nController
                                                      .notifications[index]
                                                      .photo,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                      leading: Container(
                                        height: 45,
                                        width: 45,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(17),
                                            child: image(nController
                                                .notifications[index]
                                                .sender
                                                .profilePic)),
                                      ),
                                      title: RichText(
                                        text: TextSpan(
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                            children: [
                                              TextSpan(
                                                text: nController
                                                    .notifications[index]
                                                    .sender
                                                    .name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2,
                                              ),
                                              TextSpan(
                                                text: getText(nController
                                                    .notifications[index]
                                                    .type)['firstHalf'],
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              TextSpan(
                                                text: getText(nController
                                                    .notifications[index]
                                                    .type)['secondHalf'],
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              TextSpan(
                                                text: getText(nController
                                                    .notifications[index]
                                                    .type)['thirdHalf'],
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ]),
                                      ),
                                      trailing: Text(
                                          DateFormat('h:mm a')
                                              .format(nController
                                                  .notifications[index]
                                                  .updatedAt)
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .overline
                                              .copyWith(
                                                  fontSize: 10,
                                                  color: Theme.of(context)
                                                      .shadowColor))),
                                ],
                              );
                            },
                          )
                        : Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications_off,
                                  size: 100,
                                  color: Colors.grey[300],
                                ),
                                Text(
                                  "You dont have any notification yet",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(color: Colors.grey[350]),
                                ),
                              ],
                            )));
                  },
                ))));
  }

  getText(String type) {
    switch (type) {
      case 'follow':
        return {
          'firstHalf': " has started",
          'secondHalf': " Following",
          'thirdHalf': " you"
        };
      case 'like':
        return {
          'firstHalf': " has",
          'secondHalf': " Liked",
          'thirdHalf': " your post"
        };
      case 'reply':
        return {
          'firstHalf': " has",
          'secondHalf': " Commented",
          'thirdHalf': " on your post"
        };
      case 'retweet':
        return {
          'firstHalf': " has",
          'secondHalf': " Retweeted",
          'thirdHalf': " your post"
        };
      default:
        return null;
    }
  }

  bool isToday(DateTime date) {
    if (DateTime.now().day == date.day &&
        DateTime.now().month == date.month &&
        DateTime.now().year == date.year) {
      return true;
    } else {
      return false;
    }
  }
}
