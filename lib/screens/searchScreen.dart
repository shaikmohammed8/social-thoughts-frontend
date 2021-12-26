import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/controller/mainController.dart';
import 'package:twitter_clone/models/tweets.dart';
import 'package:twitter_clone/models/user.dart';
import 'package:twitter_clone/repositories/postRepository.dart';
import 'package:twitter_clone/repositories/userRapository.dart';
import 'package:twitter_clone/utils/utlis.dart';
import 'package:twitter_clone/widgets/drawer.dart';
import 'package:twitter_clone/widgets/tweet.dart';

// ignore: must_be_immutable
class SearchScreen extends GetView<MainController> {
  var iController = Get.put(InfineListController(), tag: "seach screen");

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (c, _) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
            key: scaffoldKey,
            drawer: CustomDrawer(),
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.sort,
                  color: Colors.white,
                ),
                onPressed: () {
                  scaffoldKey.currentState.openDrawer();
                },
              ),
              title: GetBuilder<MainController>(
                init: MainController(),
                builder: (c) => Container(
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: Colors.grey[200],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: iController.textController,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: Colors.black),
                    textAlignVertical: TextAlignVertical.center,
                    maxLength: 50,
                    decoration: InputDecoration(
                      isDense: true,
                      counterText: '',
                      hintText: 'search ${c.tabName}',
                    ),
                  ),
                ),
              ),
              bottom: TabBar(
                onTap: (index) {
                  if (index == 0) {
                    Get.find<MainController>().chaneTab('user');
                  } else {
                    Get.find<MainController>().chaneTab('post');
                  }
                },
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.all(3),
                indicatorWeight: 3,
                indicatorColor: Colors.white54,
                tabs: [
                  Tab(
                    child: Text(
                      "        User        ",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  Tab(
                    child: Text('        Post        ',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(color: Colors.white)),
                  )
                ],
              ),
            ),
            body: Container(
              color: Theme.of(context).primaryColor,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: TabBarView(
                  children: [
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: iController.textController,
                      builder: (ctx, value, child) => value.text.isEmpty
                          ? child
                          : FutureBuilder<List<User>>(
                              future: UserReposiotry()
                                  .searchUsers('user?search=${value.text}'),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data.length == 0) {
                                    return Container(
                                      padding: EdgeInsets.only(top: 8),
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                          "No user found for '${value.text}'",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .copyWith(
                                                  color: Colors.grey[600])),
                                    );
                                  }
                                  return ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) => ListTile(
                                      onTap: () => Get.toNamed('profile',
                                          arguments: snapshot.data[index].id),
                                      leading: Container(
                                        height: 45,
                                        width: 45,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(17),
                                            child: image(snapshot
                                                .data[index].profilePic)),
                                      ),
                                      title: Text(snapshot.data[index].name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                      subtitle: Text(
                                          "@" + snapshot.data[index].username,
                                          style: Theme.of(context)
                                              .textTheme
                                              .overline),
                                    ),
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container(
                                      padding: EdgeInsets.only(top: 8),
                                      alignment: Alignment.topCenter,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ));
                                } else
                                  return child;
                              },
                            ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(children: [
                          Text(
                            'suggestions',
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                .copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey.shade400),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          SizedBox(height: 170, child: suggetsUsers())
                        ]),
                      ),
                    ),
                    postValuebuilder(),
                  ],
                ),
              ),
            )),
      );
    });
  }

  ValueListenableBuilder<TextEditingValue> postValuebuilder() {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: iController.textController,
      builder: (ctx, value, child) => value.text.isEmpty
          ? child
          : FutureBuilder<List<dynamic>>(
              future:
                  PostRepository().searchPost('api/posts?search=${value.text}'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  iController.addListner();
                  iController.i = 0;
                  iController.tweets.value = snapshot.data;
                  if (iController.tweets.length == 0) {
                    return Container(
                      padding: EdgeInsets.only(top: 8),
                      alignment: Alignment.topCenter,
                      child: Text("No post found for '${value.text}'",
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: Colors.grey[600])),
                    );
                  }
                  return Obx(
                    () => ListView.builder(
                      controller: iController.sController,
                      itemCount: iController.tweets.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () => Get.toNamed('tweetscreen',
                            arguments: iController.tweets[index].id),
                        child: TweetWidget(
                            retweetBy: SizedBox(),
                            name: iController.tweets[index].postBy.name,
                            username:
                                "@" + iController.tweets[index].postBy.username,
                            content: iController.tweets[index].content == null
                                ? ""
                                : iController.tweets[index].content,
                            like: isUserRetweeted(
                                iController.tweets[index].likes,
                                controller.id.value),
                            retweet: isUserRetweeted(
                                iController.tweets[index].retweets,
                                controller.id.value),
                            id: iController.tweets[index].id,
                            date: iController.tweets[index].createdAt,
                            likesCount: iController.tweets[index].likes.length,
                            tweetCount:
                                iController.tweets[index].retweets.length,
                            contentStyle: Theme.of(context).textTheme.bodyText2,
                            userId: iController.tweets[index].postBy.id,
                            proilePic:
                                iController.tweets[index].postBy.profilePic,
                            photo: iController.tweets[index].photo),
                      ),
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Container(
                      padding: EdgeInsets.only(top: 8),
                      alignment: Alignment.topCenter,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ));
                } else {
                  print(snapshot.error);
                  return child;
                }
              },
            ),
      child: Container(),
    );
  }

  bool isUserRetweeted(List retweets, String id) {
    if (retweets.length == 0 || retweets == null) {
      return false;
    }
    var isRetweeted = retweets.any((element) => element == id);
    return isRetweeted;
  }

  FutureBuilder<List<User>> suggetsUsers() {
    return FutureBuilder<List<User>>(
        future: UserReposiotry().searchUsers('user'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: EdgeInsets.only(top: 8),
              alignment: Alignment.topCenter,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true, //just set this property
              itemCount: snapshot.data.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (a, index) => Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 1.5,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            NetworkImage(snapshot.data[index].profilePic),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        snapshot.data[index].name,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      TextButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(100, 30),
                              onPrimary: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          onPressed: () {
                            Get.toNamed('profile',
                                arguments: snapshot.data[index].id);
                          },
                          child: Text("go to profile"))
                    ],
                  )),
            );
          } else
            return Container(
              height: 200,
            );
        });
  }
}

class InfineListController extends GetxController {
  TextEditingController textController = TextEditingController();
  int i = 0;
  RxList<Tweet> tweets = RxList.empty();
  ScrollController sController = ScrollController();

  void addListner() {
    sController.addListener(() async {
      if (sController.position.pixels == sController.position.maxScrollExtent) {
        var newList = await PostRepository().searchPost(
            'api/posts?search=${textController.text}&skip=${i += 5}');
        tweets.addAll(newList);
      }
    });
  }
}
