import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:twitter_clone/repositories/postRepository.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_clone/utils/utlis.dart';

// ignore: must_be_immutable
class TweetWidget extends StatefulWidget {
  final photo,
      name,
      username,
      content,
      id,
      userId,
      contentStyle,
      retweetBy,
      proilePic,
      date;
  bool like;
  bool retweet;
  int tweetCount;
  int likesCount;
  final likeHandler;

  TweetWidget(
      {Key key,
      this.contentStyle,
      this.date,
      this.tweetCount,
      this.likesCount,
      this.name,
      this.userId,
      this.id,
      this.username,
      this.content,
      this.like,
      this.proilePic,
      this.retweet,
      this.photo,
      this.retweetBy,
      this.likeHandler})
      : super(key: key);

  @override
  _TweetWidgetState createState() => _TweetWidgetState();
}

class _TweetWidgetState extends State<TweetWidget> {
  var isLiked = false;
  var postRepo = PostRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor))),
      padding: EdgeInsets.only(left: 8, right: 8, top: 8),
      child: FittedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.retweetBy,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed('profile', arguments: widget.userId);
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: image(widget.proilePic)),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 3,
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.55),
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed('profile',
                                        arguments: widget.userId);
                                  },
                                  child: Text(widget.name,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2),
                                ),
                              ),
                              Text(widget.username,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.overline),
                            ],
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                              "." +
                                  DateFormat('d MMM yy')
                                      .format(widget.date)
                                      .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .overline
                                  .copyWith(fontSize: 14)),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        widget.content.replaceAll(RegExp(r"\n+"), ""),
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 20,
                        overflow: TextOverflow.ellipsis,
                      ),
                      widget.photo == null
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.all(5),
                              child: SizedBox(
                                height: 180,
                                child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        widget.photo,
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ),
                            ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                                icon: Icon(Iconsax.more_square, size: 20),
                                onPressed: () {
                                  Get.toNamed('tweetscreen',
                                      arguments: widget.id);
                                }),
                            SizedBox(
                              width: 20,
                            ),
                            LikeButton(
                                isLiked: widget.retweet,
                                size: 30,
                                circleColor: CircleColor(
                                    start: Theme.of(context).primaryColor,
                                    end: Theme.of(context).primaryColor),
                                bubblesColor: BubblesColor(
                                  dotPrimaryColor: Colors.red,
                                  dotSecondaryColor: Colors.red,
                                ),
                                likeBuilder: (bool isLiked) {
                                  return isLiked
                                      ? Icon(
                                          Iconsax.repeat,
                                          color: Colors.green,
                                          size: 20,
                                        )
                                      : Icon(
                                          Iconsax.repeat,
                                          size: 20,
                                        );
                                },
                                likeCount: widget.tweetCount,
                                countBuilder: (i, d, s) => Text(
                                      i.toString(),
                                      style:
                                          Theme.of(context).textTheme.overline,
                                    ),
                                onTap: (isTrue) async {
                                  postRepo.retweet(
                                      "api/posts/${widget.id}/retweet");
                                  return !isTrue;
                                }),
                            SizedBox(
                              width: 20,
                            ),
                            // Wrap(
                            //   crossAxisAlignment: WrapCrossAlignment.center,
                            //   children: [
                            //     IconButton(
                            //         icon: widget.like
                            //             ? Icon(
                            //                 Iconsax.heart,
                            //                 size: 20,
                            //                 color: Colors.red,
                            //               )
                            //             : Icon(Iconsax.heart, size: 20),
                            //         onPressed: widget.likeHandler),
                            //     Text(widget.likesCount.toString(),
                            //         style: Theme.of(context)
                            //             .textTheme
                            //             .overline
                            //             .copyWith(fontSize: 14)),
                            //   ],
                            // ),
                            LikeButton(
                                isLiked: widget.like,
                                size: 30,
                                circleColor: CircleColor(
                                    start: Theme.of(context).accentColor,
                                    end: Theme.of(context).accentColor),
                                bubblesColor: BubblesColor(
                                  dotPrimaryColor:
                                      Theme.of(context).accentColor,
                                  dotSecondaryColor:
                                      Theme.of(context).accentColor,
                                ),
                                likeBuilder: (bool isLiked) {
                                  return Icon(
                                    isLiked ? Iconsax.heart5 : Iconsax.heart,
                                    color: isLiked ? Colors.red : Colors.black,
                                    size: 20,
                                  );
                                },
                                likeCount: widget.likesCount,
                                countBuilder: (i, d, s) => Text(
                                      i.toString(),
                                      style:
                                          Theme.of(context).textTheme.overline,
                                    ),
                                onTap: (bool) async {
                                  if (bool) {
                                    postRepo
                                        .like("api/posts/${widget.id}/unlike")
                                        .then((value) => null)
                                        .catchError(
                                            (onError) => print(onError));
                                  } else {
                                    postRepo
                                        .like("api/posts/${widget.id}/like")
                                        .then((value) => null)
                                        .catchError(
                                            (onError) => print(onError));
                                  }
                                  return !bool;
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
