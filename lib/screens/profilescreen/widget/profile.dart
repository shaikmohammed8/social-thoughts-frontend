import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:twitter_clone/controller/FollowController.dart';
import 'package:twitter_clone/controller/mainController.dart';
import 'package:twitter_clone/models/tweets.dart';
import 'package:twitter_clone/models/user.dart';
import 'package:twitter_clone/repositories/postRepository.dart';
import 'package:twitter_clone/utils/utlis.dart';
import 'package:twitter_clone/widgets/tweet.dart';

// ignore: must_be_immutable
class ProfileBuild extends StatefulWidget {
  ProfileBuild(this.fController,
      {this.textspan, Key key, @required this.button, @required this.snapshot})
      : super(key: key);

  final Widget button;
  FollowController fController;
  final textspan;
  final AsyncSnapshot<User> snapshot;

  @override
  _ProfileBuildState createState() => _ProfileBuildState();
}

class _ProfileBuildState extends State<ProfileBuild> {
  var postRepo = PostRepository();
  var controller = Get.find<MainController>();
  bool isWaiting = false;
  var id;
  List<Tweet> tweets = <Tweet>[];

  ScrollController sController = ScrollController();

  @override
  void initState() {
    sController.addListener(() async {
      if (sController.position.pixels == sController.position.maxScrollExtent) {
        try {
          setState(() {
            isWaiting = true;
          });
          var list = await postRepo.getPosts(
              "api/posts/${widget.snapshot.data.id}/getPosts?skip=${tweets.length}");
          setState(() {
            tweets.addAll(list);
            isWaiting = false;
          });
        } catch (e) {
          print(e);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          color: Theme.of(context).primaryColor,
          child: Stack(
            children: [
              Container(
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: image(widget.snapshot.data.profilePic)),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(widget.snapshot.data.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .copyWith(color: Colors.white))),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text('@' + widget.snapshot.data.username,
                                  style: Theme.of(context)
                                      .textTheme
                                      .overline
                                      .copyWith(color: Colors.white60)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: widget.button,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 5),
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                                style: Theme.of(context)
                                    .textTheme
                                    .overline
                                    .copyWith(color: Colors.white),
                                children: [
                                  TextSpan(
                                      text: widget
                                          .snapshot.data.following.length
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(
                                              fontSize: 15,
                                              color: Colors.white)),
                                  TextSpan(
                                    text: ' Following',
                                  )
                                ]),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          RichText(
                            text: TextSpan(
                                style: Theme.of(context)
                                    .textTheme
                                    .overline
                                    .copyWith(
                                        fontSize: 15, color: Colors.white),
                                children: [
                                  widget.textspan,
                                  TextSpan(text: ' Follower')
                                ]),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SlidingUpPanel(
                boxShadow: [],
                maxHeight: (MediaQuery.of(context).size.height - 60) -
                    MediaQuery.of(context).padding.top,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
                minHeight: (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top) -
                    260,
                panelBuilder: (s) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<List<dynamic>>(
                      future: postRepo.getUserPosts(
                          'api/posts/${widget.snapshot.data.id}/getPosts'),
                      builder: (context, snap) {
                        if (snap.hasData) {
                          tweets = snap.data;
                          return ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            controller: sController,
                            itemBuilder: (context, index) => Column(children: [
                              tweets[index].postData == null
                                  ? TweetWidget(
                                      retweetBy: SizedBox(),
                                      name: tweets[index].postBy.name,
                                      username:
                                          "@" + tweets[index].postBy.username,
                                      content: tweets[index].content == null
                                          ? ""
                                          : tweets[index].content,
                                      like: isUserRetweeted(tweets[index].likes,
                                          controller.id.value),
                                      retweet: isUserRetweeted(
                                          tweets[index].retweets,
                                          controller.id.value),
                                      id: tweets[index].id,
                                      date: tweets[index].createdAt,
                                      likesCount: tweets[index].likes.length,
                                      tweetCount: tweets[index].retweets.length,
                                      contentStyle:
                                          Theme.of(context).textTheme.bodyText2,
                                      userId: tweets[index].postBy.id,
                                      proilePic:
                                          tweets[index].postBy.profilePic,
                                      photo: tweets[index].photo)
                                  : TweetWidget(
                                      retweetBy: Wrap(children: [
                                        Icon(
                                          Iconsax.repeat,
                                          size: 18,
                                        ),
                                        Text(
                                          'Retweet by ${tweets[index].postBy.name}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .overline,
                                        )
                                      ]),
                                      name: tweets[index].postData.postBy.name,
                                      username: "@" +
                                          tweets[index]
                                              .postData
                                              .postBy
                                              .username,
                                      content:
                                          tweets[index].postData.content == null
                                              ? ""
                                              : tweets[index].postData.content,
                                      like: isUserRetweeted(
                                          tweets[index].postData.likes,
                                          controller.id.value),
                                      retweet: isUserRetweeted(
                                          tweets[index].postData.retweets,
                                          controller.id.value),
                                      id: tweets[index].postData.id,
                                      date: tweets[index].postData.createdAt,
                                      likesCount:
                                          tweets[index].postData.likes.length,
                                      tweetCount: tweets[index]
                                          .postData
                                          .retweets
                                          .length,
                                      contentStyle:
                                          Theme.of(context).textTheme.bodyText2,
                                      userId: tweets[index].postData.postBy.id,
                                      proilePic: tweets[index]
                                          .postData
                                          .postBy
                                          .profilePic,
                                      photo: tweets[index].postData.photo),
                              tweets.length != index + 1
                                  ? SizedBox()
                                  : isWaiting
                                      ? Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                            ]),
                            itemCount: tweets.length,
                          );
                        } else if (snap.connectionState ==
                            ConnectionState.waiting)
                          return Container(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ));
                        else
                          return Container();
                      }),
                ),
              ),
            ],
          ),
        ));
  }

  bool isUserRetweeted(List retweets, String id) {
    if (retweets.length == 0 || retweets == null) {
      return false;
    }
    var isRetweeted = retweets.any((element) => element == id);
    return isRetweeted;
  }
}
