import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/controller/FollowController.dart';
import 'package:twitter_clone/controller/mainController.dart';
import 'package:twitter_clone/models/user.dart';
import 'package:twitter_clone/repositories/postRepository.dart';
import 'package:twitter_clone/repositories/userRapository.dart';
import 'package:twitter_clone/screens/editprofilescreen/editprofilescreen.dart';
import 'package:twitter_clone/screens/profilescreen/widget/follwobutton.dart';
import 'package:twitter_clone/screens/profilescreen/widget/profile.dart';

// ignore: must_be_immutable
class ProfileScreen extends GetWidget<FollowController> {
  var maincontroller = Get.find<MainController>();
  var postRepo = PostRepository();
  var userRepo = UserReposiotry();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: userRepo.getUser(
            'user/${ModalRoute.of(context).settings.arguments}/profile'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (maincontroller.id.value == snapshot.data.id) {
              return ProfileBuild(
                controller,
                textspan: TextSpan(
                    text: snapshot.data.follower.length.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontSize: 15, color: Colors.white)),
                button: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      onPrimary: Colors.white,
                      elevation: 0.0,
                      minimumSize: Size(100, 30),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(30))),
                  child: Text('Edit Profile'),
                  onPressed: () {
                    Get.to(EditProfileScreen(), arguments: {
                      'name': snapshot.data.name,
                      'profilePhoto': snapshot.data.profilePic,
                      'id': snapshot.data.id
                    });
                  },
                ),
                snapshot: snapshot,
              );
            } else {
              controller.intializFollowers(
                  snapshot.data.follower, maincontroller.id.value);
              return Obx(
                () => ProfileBuild(
                  controller,
                  textspan: TextSpan(
                      text: controller.followCount.value.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(fontSize: 15, color: Colors.white)),
                  button: controller.isFollowed.value
                      ? FollowButton(
                          context: context,
                          snapshot: snapshot,
                          text: "following",
                          onPrimary: Colors.white,
                          primary: Colors.transparent,
                          onpressed: () {
                            controller.followhandler();
                            postRepo.like('user/${snapshot.data.id}/follow');
                          })
                      : FollowButton(
                          context: context,
                          snapshot: snapshot,
                          text: 'follow',
                          onPrimary: Theme.of(context).primaryColor,
                          primary: Colors.white,
                          onpressed: () {
                            controller.followhandler();
                            postRepo.like('user/${snapshot.data.id}/follow');
                          }),
                  snapshot: snapshot,
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 2,
                )));
          } else
            return error(context);
        });
  }

  Scaffold error(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (a, b, c) => ProfileScreen(),
                              settings: RouteSettings(
                                  arguments: ModalRoute.of(context)
                                      .settings
                                      .arguments)));
                    },
                  ),
                  Text(
                    "something went wrong",
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(color: Theme.of(context).dividerColor),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
