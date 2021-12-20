import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/utils/utlis.dart';

class ReplyWidget extends StatelessWidget {
  final name, username, reply, profilePic, userId;
  const ReplyWidget(
      {Key key,
      this.name,
      this.username,
      this.reply,
      this.profilePic,
      this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: FittedBox(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: image(profilePic)),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Get.toNamed('profile', arguments: userId),
                        child: Row(
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.55),
                              child: Text(name,
                                  style: Theme.of(context).textTheme.subtitle2),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Text("@" + username,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.overline),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        reply,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
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
