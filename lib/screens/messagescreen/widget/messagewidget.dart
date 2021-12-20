import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class MessageWidget extends StatelessWidget {
  MessageWidget(
      {Key key,
      this.message,
      this.cUid,
      this.time,
      this.id,
      this.sId,
      this.isGroupChat,
      this.sName,
      this.photoUrl,
      this.previousTime,
      this.perviousMessage});
  final message;
  final cUid;
  final id;
  String photoUrl;
  bool isGroupChat;
  String sName;
  String perviousMessage;
  final sId;
  DateTime previousTime;
  DateTime time;
  @override
  Widget build(BuildContext context) {
    return sId == cUid
        ? Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(bottom: 3),
            child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.end,
              runAlignment: WrapAlignment.end,
              children: [
                message == null && photoUrl != null
                    ? SizedBox(
                        height: 150,
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(0),
                            ),
                            child: photoUrl == 'nophoto'
                                ? Container(
                                    color: Theme.of(context).dividerColor,
                                  )
                                : Image.network(
                                    photoUrl,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: Theme.of(context).dividerColor,
                                      );
                                    },
                                  ),
                          ),
                        ),
                      )
                    : Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.8),
                        decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(0))),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              message.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        )),
                perviousMessage != cUid ||
                        previousTime.difference(time).inMinutes > 1
                    ? Text(DateFormat('h:mm').format(time).toString(),
                        style: Theme.of(context).textTheme.overline.copyWith(
                            fontSize: 10, color: Theme.of(context).shadowColor))
                    : SizedBox()
              ],
            ),
          )
        : otheMessageView(context);
  }

  Container otheMessageView(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: 10),
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.start,
        runAlignment: WrapAlignment.start,
        children: [
          isGroupChat
              ? GestureDetector(
                  onTap: () {
                    Get.toNamed('profile', arguments: sId);
                  },
                  child: Text(sName.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .overline
                          .copyWith(color: Colors.blueGrey)),
                )
              : SizedBox(),
          message == null && photoUrl != null
              ? SizedBox(
                  height: 150,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(0),
                      ),
                      child: photoUrl == 'nophoto'
                          ? Container(
                              color: Theme.of(context).dividerColor,
                            )
                          : Image.network(
                              photoUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Theme.of(context).dividerColor,
                                );
                              },
                            ),
                    ),
                  ),
                )
              : Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8),
                  decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(15))),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  )),
          perviousMessage != sId || previousTime.difference(time).inMinutes > 1
              ? Text(DateFormat('h:mm').format(time).toString(),
                  style: Theme.of(context).textTheme.overline.copyWith(
                      fontSize: 10, color: Theme.of(context).shadowColor))
              : SizedBox()
        ],
      ),
    );
  }
}
