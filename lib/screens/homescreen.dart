import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:twitter_clone/controller/mainController.dart';
import 'package:twitter_clone/models/tweets.dart';
import 'package:twitter_clone/repositories/postRepository.dart';
import 'package:twitter_clone/screens/bottomnavigation.dart';
import 'package:twitter_clone/services/socket.io.dart';
import 'package:twitter_clone/utils/utlis.dart';
import 'package:twitter_clone/widgets/drawer.dart';
import 'package:twitter_clone/widgets/shimmer.dart';
import 'package:twitter_clone/widgets/tweet.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var postRepo = PostRepository();
  var _future;
  var url = "api/posts/following/post?skip=0";
  Container c = Container(
    height: 400,
  );
  var isWaiting = true;
  List<Tweet> tweets = <Tweet>[];
  ScrollController sController = ScrollController();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  var mainController = Get.find<MainController>();

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
            title: SizedBox(
                height: 40, child: Image.asset('assets/images/bulb (1).png')),
            leading: IconButton(
              icon: Icon(
                Icons.sort,
                color: Colors.white,
              ),
              onPressed: () {
                scaffoldKey.currentState.openDrawer();
              },
            )),
        drawer: CustomDrawer(),
        body: Container(
          color: Theme.of(context).primaryColor,
          child: RefreshIndicator(
            key: refreshKey,
            onRefresh: () async {
              return tweets =
                  await postRepo.getPosts('api/posts/following/post?skip=0');
            },
            child: Stack(
              children: [
                Container(
                  height: 140,
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            .copyWith(color: Colors.white38),
                        children: [
                          TextSpan(
                            text: "Hello ",
                          ),
                          TextSpan(
                              text: mainController.name.value.toString(),
                              style: Theme.of(context).textTheme.headline1),
                          TextSpan(
                            text:
                                "\nthese are some thoughts from your following",
                          )
                        ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: SlidingUpPanel(
                    boxShadow: [],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    minHeight: MediaQuery.of(context).size.height - 200,
                    maxHeight: (MediaQuery.of(context).size.height - 60) -
                        MediaQuery.of(context).padding.top,
                    panelBuilder: (s) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                          future: _future,
                          builder:
                              (context, AsyncSnapshot<List<dynamic>> snapshot) {
                            if (snapshot.hasData) {
                              tweets = snapshot.data;
                              return Listview(context);
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                color: Colors.white,
                                child: ShimmerAnimation(
                                  isChat: false,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return error(
                                context,
                                () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                          pageBuilder: (a, b, c) =>
                                              BottomNavigation()));
                                },
                              );
                            } else
                              return noData(context);
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  // ignore: non_constant_identifier_names
  Widget Listview(BuildContext context) {
    return ListView.builder(
        controller: sController,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (c, index) => Column(
              children: [
                tweets[index].postData != null
                    ? TweetWidget(
                        retweetBy: Wrap(children: [
                          Icon(
                            Iconsax.repeat,
                            size: 18,
                            color: Colors.grey[400],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Repost by ${tweets[index].postBy.name}',
                              style: Theme.of(context).textTheme.overline,
                            ),
                          )
                        ]),
                        name: tweets[index].postData.postBy.name,
                        username: "@" + tweets[index].postData.postBy.username,
                        content: tweets[index].postData.content == null
                            ? ""
                            : tweets[index].postData.content,
                        like: isUserRetweeted(tweets[index].postData.likes,
                            mainController.id.value),
                        retweet: isUserRetweeted(
                            tweets[index].postData.retweets,
                            mainController.id.value),
                        id: tweets[index].postData.id,
                        date: tweets[index].postData.createdAt,
                        likesCount: tweets[index].postData.likes.length,
                        tweetCount: tweets[index].postData.retweets.length,
                        contentStyle: Theme.of(context).textTheme.bodyText2,
                        userId: tweets[index].postData.postBy.id,
                        proilePic: tweets[index].postData.postBy.profilePic,
                        photo: tweets[index].postData.photo)
                    : TweetWidget(
                        retweetBy: SizedBox(),
                        name: tweets[index].postBy.name,
                        username: "@" + tweets[index].postBy.username,
                        content: tweets[index].content == null
                            ? ""
                            : tweets[index].content,
                        like: isUserRetweeted(
                            tweets[index].likes, mainController.id.value),
                        retweet: isUserRetweeted(
                            tweets[index].retweets, mainController.id.value),
                        id: tweets[index].id,
                        date: tweets[index].createdAt,
                        likesCount: tweets[index].likes.length,
                        tweetCount: tweets[index].retweets.length,
                        userId: tweets[index].postBy.id,
                        proilePic: tweets[index].postBy.profilePic,
                        photo: tweets[index].photo),
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
              ],
            ),
        itemCount: tweets.length);
  }

  bool isUserRetweeted(List retweets, String id) {
    if (retweets.length == 0 || retweets == null) {
      return false;
    }
    var isRetweeted = retweets.any((element) => element == id);
    return isRetweeted;
  }

  Container noData(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.voice_over_off_rounded,
                  size: 150,
                  color: Theme.of(context).dividerColor,
                ),
                Text(
                  "You dont have any post yet plz follow more",
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(color: Theme.of(context).dividerColor),
                ),
              ],
            ),
          ),
        ));
  }

  void initState() {
    _future = postRepo.getPosts('api/posts/following/post?skip=0');
    SocketHandler.socket.on('like', (data) {
      List likes = data['likes'];

      for (var i = 0; i < tweets.length; i++) {
        var tweet = tweets[i];

        if (tweet.id == data['_id']) {
          setState(() {
            tweet.likes = likes;
          });
          return;
        }
      }
    });
    SocketHandler.socket.on('retweet', (data) {
      List retweets = data['retweets'];
      for (var i = 0; i < tweets.length; i++) {
        var tweet = tweets[i];

        if (tweet.id == data['_id']) {
          setState(() {
            tweet.retweets = retweets;
          });
          return;
        }
      }
    });

    sController.addListener(() async {
      if (sController.position.pixels == sController.position.maxScrollExtent) {
        setState(() {
          isWaiting = true;
        });
        var list = await postRepo
            .getPosts("api/posts/following/post?skip=${tweets.length}");

        setState(() {
          tweets.addAll(list);
          isWaiting = false;
        });
      }
    });
    super.initState();
  }
}
