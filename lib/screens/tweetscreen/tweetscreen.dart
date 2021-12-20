import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/controller/likecontroller.dart';
import 'package:twitter_clone/models/tweets.dart';
import 'package:twitter_clone/repositories/postRepository.dart';
import 'package:twitter_clone/screens/tweetscreen/widget/postHeader.dart';
import 'package:twitter_clone/widgets/reply.dart';

// ignore: must_be_immutable
class TweetScreen extends GetWidget<LikeController> {
  ScrollController _scrollController = ScrollController();
  var postRepo = PostRepository();
  var textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: postRepo.getSinglePost(
            'api/posts/${ModalRoute.of(context).settings.arguments}'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Tweet tweet = snapshot.data;
            controller.fetchReplies(tweet.reply);
            return Scaffold(
              extendBody: false,
              appBar: AppBar(),
              body: Container(
                color: Theme.of(context).primaryColor,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  padding: const EdgeInsets.only(
                      top: 8, left: 8, right: 8, bottom: 78),
                  child: Column(
                    children: [
                      Flexible(
                        child: Obx(() {
                          return ListView.separated(
                            controller: _scrollController,
                            // ignore: invalid_use_of_protected_member
                            itemCount: controller.replyList.value == null
                                ? 1
                                : controller.replyList.length + 1,
                            itemBuilder: (ctx, index) => index == 0
                                ? PostHeader(
                                    tweet: tweet, controller: controller)
                                : ReplyWidget(
                                    reply:
                                        controller.replyList[(index - 1)].reply,
                                    name: controller
                                        .replyList[(index - 1)].userId.name,
                                    username: controller
                                        .replyList[(index - 1)].userId.username,
                                    profilePic: controller
                                        .replyList[(index - 1)]
                                        .userId
                                        .profilePic,
                                    userId: controller
                                        .replyList[(index - 1)].userId.id,
                                  ),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider(
                                thickness: 0.5,
                              );
                            },
                          );
                        }),
                      )
                    ],
                  ),
                ),
              ),
              bottomSheet: Container(
                height: 78,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top:
                            BorderSide(color: Theme.of(context).dividerColor))),
                padding: EdgeInsets.all(8),
                child: Wrap(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Get.toNamed('profile', arguments: tweet.postBy.id),
                      child: Row(
                        children: [
                          Text("repy to ",
                              style: Theme.of(context).textTheme.overline),
                          Flexible(
                            child: Text("@" + tweet.postBy.username,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .overline
                                    .copyWith(
                                        color: Theme.of(context).accentColor)),
                          )
                        ],
                      ),
                    ),
                    TextField(
                      maxLines: 2,
                      minLines: 1,
                      style: Theme.of(context).textTheme.caption,
                      textAlignVertical: TextAlignVertical.center,
                      controller: textcontroller,
                      maxLength: 300,
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'type something here',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: Colors.black26),
                        suffixIcon: FittedBox(
                            child: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: textcontroller,
                          builder: (BuildContext context, value, Widget child) {
                            return ElevatedButton(
                              onPressed: value.text.trim().isEmpty
                                  ? null
                                  : () => onTap(tweet),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(35, 30),
                                  onPrimary: Colors.white,
                                  primary: Theme.of(context).primaryColor,
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35))),
                              child: Text("send"),
                            );
                          },
                        )),
                      ),
                    )
                  ],
                ),
              ),
              resizeToAvoidBottomInset: true,
            );
          } else
            return Scaffold(
              appBar: AppBar(),
              body: Container(
                color: Theme.of(context).primaryColor,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
            );
        });
  }

  onTap(tweet) async {
    var reply = await postRepo.reply(
        "api/posts/${tweet.id}/reply", textcontroller.text);
    textcontroller.clear();
    controller.addReply(reply);
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }
}
