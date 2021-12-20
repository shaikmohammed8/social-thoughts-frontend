import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:twitter_clone/controller/mainController.dart';
import 'package:twitter_clone/models/user.dart';
import 'package:twitter_clone/repositories/postRepository.dart';
import 'package:twitter_clone/repositories/userRapository.dart';
import 'package:twitter_clone/utils/utlis.dart';

// ignore: must_be_immutable
class CustomDrawer extends GetView<MainController> {
  var postRepo = PostRepository();
  var userRepo = UserReposiotry();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            FutureBuilder<User>(
                future: userRepo.getUser("user/${controller.id.value}/profile"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return DrawerHeader(
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    return DrawerHeader(
                        child: Container(
                      decoration: BoxDecoration(),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 45,
                            width: 45,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(17),
                                child: cachedImage(snapshot.data.profilePic)),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            snapshot.data.name,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          Text(
                            "@" + snapshot.data.username,
                            style: Theme.of(context).textTheme.overline,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                      style:
                                          Theme.of(context).textTheme.overline,
                                      children: [
                                        TextSpan(
                                            text: snapshot.data.following.length
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2
                                                .copyWith(fontSize: 15)),
                                        TextSpan(text: ' Following')
                                      ]),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                RichText(
                                  text: TextSpan(
                                      style:
                                          Theme.of(context).textTheme.overline,
                                      children: [
                                        TextSpan(
                                            text: snapshot.data.follower.length
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2
                                                .copyWith(fontSize: 15)),
                                        TextSpan(text: ' Follower')
                                      ]),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ));
                  } else
                    return DrawerHeader(
                      child: Center(
                        child: Container(),
                      ),
                    );
                }),
            ListTile(
              leading:
                  Icon(Iconsax.user, color: Theme.of(context).iconTheme.color),
              title: Text('Pofile'),
              onTap: () {
                Get.toNamed('profile', arguments: controller.id.value);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app,
                  color: Theme.of(context).iconTheme.color),
              title: Text('Logout'),
              onTap: () {
                controller.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
