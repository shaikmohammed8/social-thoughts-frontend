import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/controller/ChatController.dart';
import 'package:twitter_clone/models/user.dart';
import 'package:twitter_clone/repositories/userRapository.dart';
import 'package:twitter_clone/screens/groupeditscreen/groupeditscreen.dart';
import 'package:twitter_clone/utils/utlis.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  var textController = TextEditingController();

  ChatScreen({Key key}) : super(key: key);
  var controller = Get.find<ChatController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedSwitcher(
                switchInCurve: Curves.linear,
                switchOutCurve: Curves.linear,
                duration: Duration(milliseconds: 200),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: controller.list.isEmpty
                    ? IconButton(
                        key: Key('s'),
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                    : Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          IconButton(
                              key: Key('d'),
                              icon: Icon(Icons.close),
                              onPressed: () {
                                controller.list.clear();
                              }),
                          Text(
                            controller.list.length.toString(),
                            style: Theme.of(context).textTheme.caption.copyWith(
                                color: Theme.of(context).primaryColor),
                          )
                        ],
                      ),
              ),
              ElevatedButton(
                onPressed: controller.list.isEmpty
                    ? null
                    : () {
                        if (controller.list.length == 1) {
                          Get.toNamed("messagescreen", arguments: {
                            'isGroup': false,
                            "id": controller.list.first.id,
                            'name': controller.list.first.name,
                            'photo': controller.list.first.profilePic
                          });
                        } else if (controller.list.length > 1) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (c) => GroupEditScreen(),
                              settings: RouteSettings(arguments: {
                                'name': '',
                                'photo':
                                    'https://res.cloudinary.com/ddafqnkvv/image/upload/v1629303235/profile/twiiter_agebux.png'
                              })));
                        }
                      },
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Theme.of(context).primaryColor,
                    minimumSize: Size(35, 30),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35))),
                child: Text("next"),
              )
            ],
          ),
        ),
      ),

      //body of screen
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Container(
          padding: EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            children: [
              Obx(
                () => AnimatedContainer(
                  padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  height: controller.list.isEmpty ? 0 : 65,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ...controller.list.map((element) => Stack(
                                children: [
                                  TweenAnimationBuilder(
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    duration: Duration(milliseconds: 200),
                                    builder: (ctx, tween, child) => Container(
                                      alignment: Alignment.bottomCenter,
                                      height: tween * 55,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(17),
                                            child: image(element.profilePic)),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      child: GestureDetector(
                                        onTap: () =>
                                            controller.list.remove(element),
                                        child: CircleAvatar(
                                            backgroundColor: Colors.green,
                                            radius: 10,
                                            child: Icon(
                                              Icons.close_rounded,
                                              size: 18,
                                              color: Colors.white,
                                            )),
                                      ))
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Theme.of(context).dividerColor,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: textController,
                    style: Theme.of(context).textTheme.caption,
                    textAlignVertical: TextAlignVertical.center,
                    maxLength: 50,
                    decoration: InputDecoration(
                      isDense: true,
                      counterText: '',
                      hintText: 'search user',
                    ),
                  )),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: textController,
                builder: (ctx, value, child) => value.text.isEmpty
                    ? child
                    : Expanded(
                        child: FutureBuilder<List>(
                          future: UserReposiotry()
                              .searchUsers('user?search=${value.text}'),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<User> users = snapshot.data;
                              if (users.length == 0) {
                                return Container(
                                  padding: EdgeInsets.only(top: 8),
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                      "No user found for '${value.text}'",
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(color: Colors.grey[600])),
                                );
                              }
                              return ListView.builder(
                                itemCount: users.length,
                                itemBuilder: (context, index) => ListTile(
                                  onTap: () =>
                                      controller.onSelect(users[index]),
                                  leading: Container(
                                    height: 45,
                                    width: 45,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(17),
                                        child: image(users[index].profilePic)),
                                  ),
                                  title: Text(users[index].name,
                                      style:
                                          Theme.of(context).textTheme.caption),
                                  subtitle: Text("@" + users[index].username,
                                      style:
                                          Theme.of(context).textTheme.overline),
                                  trailing: Obx(
                                    () => controller.list.any((element) =>
                                            element.id == users[index].id)
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Icon(
                                              Icons.check_circle,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          )
                                        : SizedBox(),
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
                            } else
                              return child;
                          },
                        ),
                      ),
                child: Container(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
