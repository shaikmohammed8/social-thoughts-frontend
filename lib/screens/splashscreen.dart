import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).primaryColor,
        child: Column(children: [
          Spacer(
            flex: 1,
          ),
          SizedBox(
            height: 100,
            child: Image.asset('assets/images/bulb (1).png'),
          ),
          Spacer(),
          Text(
            "Desinged and developed by mohammed",
            style: TextStyle(
                color: Colors.white, fontSize: 16, letterSpacing: 1.5),
          ),
          SizedBox(
            height: 100,
          )
        ]),
      ),
    );
  }
}
