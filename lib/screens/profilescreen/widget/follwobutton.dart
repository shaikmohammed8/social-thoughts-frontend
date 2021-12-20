import 'package:flutter/material.dart';
import 'package:twitter_clone/models/user.dart';

// ignore: must_be_immutable
class FollowButton extends StatelessWidget {
  FollowButton({
    this.context,
    this.snapshot,
    this.text,
    this.onPrimary,
    this.primary,
    this.onpressed,
    Key key,
  }) : super(key: key);
  BuildContext context;
  AsyncSnapshot<User> snapshot;
  String text;
  Color onPrimary;
  Color primary;
  Function onpressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            onPrimary: onPrimary,
            primary: primary,
            elevation: 0.0,
            minimumSize: Size(100, 30),
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(30))),
        child: Text(text),
        onPressed: onpressed);
  }
}
