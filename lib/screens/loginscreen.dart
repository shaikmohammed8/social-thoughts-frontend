import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/controller/mainController.dart';
import 'package:twitter_clone/repositories/authRepository.dart';
import 'package:twitter_clone/screens/signupscreen.dart';

// ignore: must_be_immutable
class LoginScreen extends GetView<MainController> {
  var authRepo = AuthRepository();
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Spacer(
                  flex: 1,
                ),
                SizedBox(
                  height: 70,
                  child: Image.asset('assets/images/bulb (1).png'),
                ),
                Spacer(
                  flex: 1,
                ),
                Text('Welcome Back',
                    style: Theme.of(context).textTheme.headline1),
                textfield("Email", Icons.email_rounded, emailcontroller, (val) {
                  if (!GetUtils.isEmail(
                    val,
                  )) {
                    return "please enter valid email";
                  } else
                    return null;
                }, TextInputType.emailAddress, false, context),
                textfield("Password", Icons.lock, passwordcontroller, (val) {
                  if (!GetUtils.isLengthGreaterOrEqual(val, 6)) {
                    return "please enter valid password";
                  } else
                    return null;
                }, TextInputType.visiblePassword, true, context),
                Obx(
                  () => AnimatedContainer(
                    height: 40,
                    duration: Duration(milliseconds: 200),
                    width: controller.isWaiting.value ? 60 : 150,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          controller.isWaiting.value = true;
                          await authRepo.login(
                              emailcontroller.text, passwordcontroller.text);
                          controller.isWaiting.value = false;
                        }
                      },
                      child: controller.isWaiting.value
                          ? SizedBox(
                              height: 25,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ))
                          : Text(
                              'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                      style: ElevatedButton.styleFrom(
                          // minimumSize: Size(150, 40),
                          primary: Colors.white,
                          textStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          )),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                                children: [
                              TextSpan(text: 'does not have an account?'),
                              TextSpan(
                                  text: " sing up",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (s) => SingupScreen()));
                                    })
                            ])),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container textfield(
      String hintext,
      IconData iconData,
      TextEditingController controller,
      Function validator,
      TextInputType keyboard,
      bool password,
      context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: keyboard,
        obscureText: password,
        style:
            Theme.of(context).textTheme.caption.copyWith(color: Colors.black),
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
            isDense: true,
            prefixIcon: Icon(
              iconData,
              color: Colors.grey[400],
              size: 16,
            ),
            hintText: hintext,
            filled: true,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
            fillColor: Colors.white,
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none)),
      ),
    );
  }
}
