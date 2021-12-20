import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/controller/mainController.dart';
import 'package:twitter_clone/repositories/authRepository.dart';
import 'package:twitter_clone/screens/loginscreen.dart';

// ignore: must_be_immutable
class SingupScreen extends GetView<MainController> {
  var authRepo = SignupReposiory();
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  var namecontroller = TextEditingController();
  // ignore: non_constant_identifier_names
  var Cpasswordcontroller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Wrap(
                              children: [
                                SizedBox(
                                  height: 70,
                                  child:
                                      Image.asset('assets/images/bulb (1).png'),
                                ),
                              ],
                            ),
                          ),
                          Text('Welcome',
                              style: Theme.of(context).textTheme.headline1),
                          textfield(
                              "Email", Icons.email_rounded, emailcontroller,
                              (val) {
                            if (!GetUtils.isEmail(val.trim())) {
                              return "please enter valid email";
                            } else if (val.length >= 40) {
                              return "lenght should be smaller than 40";
                            } else
                              return null;
                          }, TextInputType.emailAddress, false, context,
                              max: 40),
                          textfield(
                              "Username", Icons.person_rounded, namecontroller,
                              (String val) {
                            if (!GetUtils.isUsername(val.trim())) {
                              return "please enter valid username";
                            } else if (val.length >= 15) {
                              return "lenght should be smaller than 15";
                            } else
                              return null;
                          }, TextInputType.name, false, context, max: 15),
                          textfield("Password", Icons.lock, passwordcontroller,
                              (val) {
                            if (!GetUtils.isLengthGreaterOrEqual(
                                val.trim(), 6)) {
                              return "please enter valid password";
                            } else if (val.length >= 20) {
                              return "lenght should be smaller than 20";
                            } else {
                              return null;
                            }
                          }, TextInputType.visiblePassword, true, context,
                              max: 20,
                              onChange: chekPassword,
                              trialing: Obx(() =>
                                  controller.password.value == "none"
                                      ? SizedBox()
                                      : Text(controller.password.value))),
                          textfield("confirm password", Icons.lock,
                              Cpasswordcontroller, (val) {
                            if (passwordcontroller.text != val.trim()) {
                              return "password doesnt match";
                            } else
                              return null;
                          }, TextInputType.visiblePassword, true, context),
                          Obx(
                            () => AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: controller.isWaiting.value ? 60 : 150,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState.validate()) {
                                    controller.isWaiting.value = true;

                                    authRepo.singup(
                                        emailcontroller.text,
                                        passwordcontroller.text,
                                        namecontroller.text);

                                    controller.isWaiting.value = false;
                                  } else {}
                                },
                                child: controller.isWaiting.value
                                    ? SizedBox(
                                        height: 25,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        'Singup',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                style: ElevatedButton.styleFrom(
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
                        ],
                      ),
                      RichText(
                          text: TextSpan(
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              children: [
                            TextSpan(text: 'already have an account?'),
                            TextSpan(
                                text: " Login",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (s) => LoginScreen()));
                                  })
                          ]))
                    ],
                  ),
                ),
              ),
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
      context,
      {trialing = const SizedBox(),
      int max,
      // ignore: avoid_init_to_null
      Function onChange = null}) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: TextFormField(
        style:
            Theme.of(context).textTheme.caption.copyWith(color: Colors.black),
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        keyboardType: keyboard,
        obscureText: password,
        maxLength: max,
        onChanged: onChange,
        validator: validator,
        decoration: InputDecoration(
            counterText: '',
            suffix: trialing,
            isDense: true,
            prefixIcon: Icon(
              iconData,
              color: Colors.grey[350],
              size: 16,
            ),
            hintText: hintext,
            filled: true,
            hintStyle: TextStyle(color: Colors.grey[350], fontSize: 16),
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

  void chekPassword(val) {
    if (passwordcontroller.text.contains(RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'))) {
      controller.password.value = "💪";
    } else if (passwordcontroller.text
        .contains(RegExp(r'^(?=.*?[!@#\$&*~]).{8,}'))) {
      controller.password.value = '👍';
    } else
      controller.password.value = '👎';
  }
}
