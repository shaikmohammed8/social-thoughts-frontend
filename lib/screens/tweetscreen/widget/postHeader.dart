import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_clone/controller/likecontroller.dart';
import 'package:twitter_clone/controller/mainController.dart';

import 'package:twitter_clone/models/tweets.dart';
import 'package:twitter_clone/repositories/postRepository.dart';
import 'package:twitter_clone/utils/utlis.dart';

// ignore: must_be_immutable
class PostHeader extends StatelessWidget {
  PostHeader({this.tweet, Key key, this.controller}) : super(key: key);
  PostRepository postRepo = PostRepository();
  final controller;
  var mainController = Get.find<MainController>();
  Tweet tweet;
  @override
  Widget build(BuildContext context) {
    return tweet.postData == null
        ? CostumTweet(
            controller: controller,
            profilePic: tweet.postBy.profilePic,
            userId: tweet.postBy.id,
            name: tweet.postBy.name,
            username: tweet.postBy.username,
            content: tweet.content,
            photo: tweet.photo,
            createdAt: tweet.createdAt,
            id: tweet.id,
            likes: tweet.likes,
            retweets: tweet.retweets,
            mainController: mainController,
          )
        : CostumTweet(
            controller: controller,
            profilePic: tweet.postData.postBy.profilePic,
            userId: tweet.postData.postBy.id,
            name: tweet.postData.postBy.name,
            username: tweet.postData.postBy.username,
            content: tweet.postData.content,
            photo: tweet.postData.photo,
            createdAt: tweet.postData.createdAt,
            id: tweet.postData.id,
            likes: tweet.postData.likes,
            retweets: tweet.postData.retweets,
            mainController: mainController,
          );
  }
}

// ignore: must_be_immutable
class CostumTweet extends StatelessWidget {
  LikeController controller;
  final profilePic;
  final userId;
  final name;
  final username;
  final content;
  final photo;
  final createdAt;
  final id;
  final likes;
  final retweets;
  final mainController;
  var postRepo = PostRepository();

  CostumTweet(
      {this.controller,
      this.profilePic,
      this.userId,
      this.content,
      this.photo,
      this.likes,
      this.retweets,
      this.name,
      this.username,
      this.createdAt,
      this.id,
      this.mainController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: Container(
                        height: 45,
                        width: 45,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(17),
                            child: image(profilePic)),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('profile', arguments: userId);
                          },
                          child: Text(name,
                              style: Theme.of(context).textTheme.subtitle2),
                        ),
                        Text("@" + username,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.overline),
                        SizedBox(
                          height: 5,
                        )
                      ],
                    )
                  ],
                ),
                Text(
                  content.replaceAll(RegExp(r"\n+"), ""),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                photo == null
                    ? SizedBox()
                    : SizedBox(
                        height: 180,
                        child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                photo,
                                fit: BoxFit.cover,
                              ),
                            )),
                      ),
                SizedBox(
                  height: 5,
                ),
                Text(
                    DateFormat('mm:hh a').format(createdAt).toString() +
                        " . " +
                        DateFormat('d MMM yy').format(createdAt).toString(),
                    style: Theme.of(context)
                        .textTheme
                        .overline
                        .copyWith(fontSize: 14)),
                SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: Theme.of(context).dividerColor,
                              width: 0.6),
                          bottom: BorderSide(
                              color: Theme.of(context).dividerColor,
                              width: 0.6))),
                  child: LayoutBuilder(builder: (ctx, _) {
                    controller.initializValues(
                        likes, retweets, mainController.id.value);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            icon: Icon(Iconsax.archive_1), onPressed: null),
                        Obx(
                          () => LikeButton(
                              isLiked: controller.isRetweeted.value,
                              size: 30,
                              circleColor: CircleColor(
                                  start: Theme.of(context).primaryColor,
                                  end: Theme.of(context).primaryColor),
                              bubblesColor: BubblesColor(
                                dotPrimaryColor: Colors.green,
                                dotSecondaryColor: Colors.green,
                              ),
                              likeBuilder: (bool isLiked) {
                                return isLiked
                                    ? Icon(
                                        Iconsax.repeat,
                                        color: Colors.green,
                                        size: 24,
                                      )
                                    : Icon(
                                        Iconsax.repeat,
                                        size: 24,
                                      );
                              },
                              likeCount: controller.retweetCount.value,
                              countBuilder: (i, d, s) => Text(
                                    i.toString(),
                                    style: Theme.of(context).textTheme.overline,
                                  ),
                              onTap: (isTrue) async {
                                await postRepo.retweet("api/posts/$id/retweet");
                                return !isTrue;
                              }),
                        ),
                        Obx(
                          () => LikeButton(
                            isLiked: controller.isLikeorFollowed.value,
                            size: 30,
                            circleColor: CircleColor(
                                start: Theme.of(context).accentColor,
                                end: Theme.of(context).accentColor),
                            bubblesColor: BubblesColor(
                              dotPrimaryColor: Theme.of(context).accentColor,
                              dotSecondaryColor: Theme.of(context).accentColor,
                            ),
                            likeBuilder: (bool isLiked) {
                              return Icon(
                                isLiked ? Iconsax.heart5 : Iconsax.heart,
                                color: isLiked ? Colors.red : Colors.black,
                                size: 24,
                              );
                            },
                            likeCount: controller.likeOrfollwedCount.value,
                            countBuilder: (i, d, s) => Text(
                              i.toString(),
                              style: Theme.of(context).textTheme.overline,
                            ),
                            onTap: (bool isLiked) async {
                              if (isLiked) {
                                await postRepo.like("api/posts/$id/unlike");
                              } else {
                                await postRepo.like("api/posts/$id/like");
                              }
                              return !isLiked;
                            },
                          ),
                        ),
                      ],
                    );
                  }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
