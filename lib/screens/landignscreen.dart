import 'package:flutter/material.dart';
import 'package:twitter_clone/screens/loginscreen.dart';
import 'package:twitter_clone/screens/signupscreen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Spacer(),
                SizedBox(
                  width: double.infinity - 500,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Image.asset("assets/images/Tweet-[remix].gif"),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            color: Theme.of(context).primaryColor,
                            width: 100,
                            height: 50,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Text(
                    'See what\'s heppning in the world right now',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (c) => LoginScreen()));
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 40),
                      primary: Colors.white,
                      textStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (c) => SingupScreen()));
                    },
                    child: Text('Signup'),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 40),
                        primary: Theme.of(context).primaryColor,
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        )),
                  ),
                ),
                Spacer(
                  flex: 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
