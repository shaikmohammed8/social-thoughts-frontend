import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/controller/mainController.dart';
import 'package:twitter_clone/screens/homescreen.dart';
import 'package:twitter_clone/screens/inboxscreen.dart';
import 'package:twitter_clone/screens/notifications/notificationsscreen.dart';
import 'package:twitter_clone/screens/searchScreen.dart';
import 'package:twitter_clone/utils/animteicon.dart';
import 'package:twitter_clone/widgets/postwdget.dart';

// ignore: must_be_immutable
class BottomNavigation extends StatefulWidget {
  BottomNavigation({Key key, this.indexx = 0}) : super(key: key);

  var indexx;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<BottomNavigation> {
  bool isOpen = false;
  var controller = Get.find<MainController>();

  var animateController = AnimateIconController();

  List<Widget> screens = [
    HomeScreen(),
    SearchScreen(),
    NotificationScreen(),
    InboxScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: IndexedStack(children: screens, index: widget.indexx),
      bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
        CustomPaint(
          painter: RPSCustomPainter(),
          child: Container(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ButtonIcon(Iconsax.home, widget.indexx == 0, onPressed: () {
                  setState(() {
                    widget.indexx = 0;
                  });
                }),
                ButtonIcon(Iconsax.search_normal_1, widget.indexx == 1,
                    onPressed: () {
                  setState(() {
                    widget.indexx = 1;
                  });
                }),
                SizedBox(
                  height: 45,
                  width: 45,
                  child: FloatingActionButton(
                      child: Icon(
                        Iconsax.add,
                        size: 30,
                        color: Theme.of(context).dividerColor,
                      ),
                      backgroundColor: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 2, color: Theme.of(context).accentColor),
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: () {
                        setState(() {
                          isOpen = !isOpen;
                        });
                      }),
                ),
                ButtonIcon(Iconsax.notification_1, widget.indexx == 2,
                    onPressed: () {
                  setState(() {
                    widget.indexx = 2;
                  });
                }),
                Stack(
                  children: [
                    ButtonIcon(Iconsax.direct, widget.indexx == 3,
                        onPressed: () {
                      setState(() {
                        widget.indexx = 3;
                      });
                    }),
                    Obx(
                      () => Positioned(
                        right: 0,
                        bottom: 0,
                        child: controller.useenMessages.value == 0
                            ? SizedBox()
                            : CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.red,
                                child: Text(
                                  (controller.useenMessages.value +
                                          controller.unseenGroupMessage.value)
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          color: Theme.of(context).primaryColor,
          height: isOpen ? MediaQuery.of(context).size.height * 0.6 : 0,
          child: isOpen
              ? PostWeidget()
              : Container(
                  color: Colors.white,
                ),
        )
      ]),
    );
  }

  // ignore: non_constant_identifier_names
  IconButton ButtonIcon(IconData icon, bool cond, {Function onPressed}) {
    return IconButton(
        icon: Icon(
          icon,
          size: 24,
        ),
        color: cond
            ? Theme.of(context).accentColor
            : Theme.of(context).accentColor.withOpacity(0.4),
        onPressed: onPressed);
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;

    paint.strokeWidth = 2;
    Path path = Path();

    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(size.width / 2, -15, size.width, 60 * 0.3);
    path.lineTo(size.width, size.height * 0.3);

    path.lineTo(size.width, size.height);

    path.lineTo(0, size.height);

    canvas.drawShadow(path.shift(Offset(0, -11)), Colors.black54, 3.1, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
