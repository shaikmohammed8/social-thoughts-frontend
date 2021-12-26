import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:twitter_clone/controller/mainController.dart';
import 'package:twitter_clone/repositories/postRepository.dart';
import 'dart:io';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:twitter_clone/utils/utlis.dart';
import 'package:twitter_clone/credeantials/cloudainary.dart' as cd;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class PostWeidget extends GetView<MainController> {
  var postRepo = PostRepository();

  var cloud = Cloudinary(
      cd.Cloudinary.API_KEY, cd.Cloudinary.API_SECRET, cd.Cloudinary.API_ENV);
  var _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: cachedImage(controller.profilePic.value)),
                  ),
                  SizedBox(width: 5),
                  Flexible(
                    child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 300,
                              child: TextFormField(
                                controller: controller.postTextController,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(color: Colors.black),
                                maxLines: 3,
                                cursorColor: Theme.of(context).accentColor,
                                minLines: 3,
                                maxLength: 315,
                                textAlignVertical: TextAlignVertical.bottom,
                                decoration: InputDecoration(
                                    counterText: '',
                                    enabledBorder: border(context),
                                    focusedBorder: border(context),
                                    border: border(context),
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .overline
                                        .copyWith(
                                            color: Theme.of(context)
                                                .accentColor
                                                .withOpacity(0.4)),
                                    hintText: "What's heppening"),
                              ),
                            ),
                            Obx(() => controller.img.value == ''
                                ? Row(children: [
                                    IconButton(
                                        icon: Icon(
                                          Iconsax.gallery,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        onPressed: () {
                                          openGallery();
                                        }),
                                    IconButton(
                                        icon: Icon(
                                          CupertinoIcons.camera,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        onPressed: () {
                                          openCamera();
                                        }),
                                  ])
                                : GestureDetector(
                                    onTap: () => controller.img.value = '',
                                    child: Container(
                                        padding: EdgeInsets.only(top: 5),
                                        height: 60,
                                        width: 80,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            File(controller.img.value),
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                  )),
                            Center(
                              child: ValueListenableBuilder<TextEditingValue>(
                                valueListenable: controller.postTextController,
                                builder: (c, v, w) => Obx(
                                  () => AnimatedContainer(
                                      duration: Duration(milliseconds: 100),
                                      width:
                                          controller.isWaiting.value ? 60 : 150,
                                      child: ElevatedButton(
                                        child: SizedBox(
                                          width: 150,
                                          height: 40,
                                          child: AnimatedSwitcher(
                                            transitionBuilder: (w, a) =>
                                                ScaleTransition(
                                              scale: a,
                                              child: w,
                                            ),
                                            duration:
                                                Duration(milliseconds: 100),
                                            child: controller.isWaiting.value
                                                ? SizedBox(
                                                    height: 25,
                                                    width: 25,
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .accentColor,
                                                        strokeWidth: 2,
                                                      ),
                                                    ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                        Flexible(
                                                          flex: 2,
                                                          child: CustomPaint(
                                                            painter: customPaint(
                                                                color: v.text
                                                                            .length ==
                                                                        315
                                                                    ? Colors.red
                                                                    : Theme.of(
                                                                            context)
                                                                        .dividerColor,
                                                                progress: v
                                                                    .text.length
                                                                    .toDouble()),
                                                            child: Container(
                                                              height: 18,
                                                              width: 18,
                                                            ),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          fit: FlexFit.tight,
                                                          flex: 1,
                                                          child: Container(),
                                                        ),
                                                        Flexible(
                                                          flex: 3,
                                                          child: Text(
                                                            'post',
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                        Flexible(
                                                          fit: FlexFit.tight,
                                                          flex: 2,
                                                          child: Container(),
                                                        )
                                                      ]),
                                          ),
                                        ),
                                        onPressed: v.text.trim().isEmpty
                                            ? null
                                            : () {
                                                onpressed(v);
                                              },
                                        style: ElevatedButton.styleFrom(
                                            primary:
                                                Theme.of(context).accentColor,
                                            onPrimary:
                                                Theme.of(context).dividerColor,
                                            elevation: 1,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            )),
                                      )),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  double cal(val) {
    var i = ((val / 300) * 100).toInt();
    String s;
    if (i < 10)
      s = '0.0' + i.toString();
    else if (i == 100)
      s = '1';
    else
      s = '0.' + i.toString();
    return double.parse(s.toString());
  }

  OutlineInputBorder border(context) {
    return OutlineInputBorder(
        borderSide:
            BorderSide(color: Theme.of(context).accentColor, width: 1.2));
  }

  Future<void> openCamera() async {
    if (Get.isBottomSheetOpen) Get.back();
    final XFile image = await _picker.pickImage(
        source: ImageSource.camera, maxHeight: 400, maxWidth: 600);
    if (image != null) cropImage(image);
  }

  Future<void> openGallery() async {
    if (Get.isBottomSheetOpen) Get.back();
    final XFile image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) cropImage(image);
  }

  Future<void> cropImage(XFile image) async {
    File croppedFile = await ImageCropper.cropImage(
        compressQuality: 50,
        aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
        sourcePath: image.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop your photo',
            toolbarColor: Theme.of(Get.context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            hideBottomControls: true,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      controller.img.value = croppedFile.path;
    }
  }

  onpressed(v) async {
    if (controller.isWaiting.value == true) {
      return;
    }
    try {
      controller.isWaiting.value = true;
      if (controller.img.value == '') {
        postRepo.tweet(
            v.text.trim().replaceAll(RegExp(r"\n+"), ""), 'api/posts', null);
      } else {
        CloudinaryResponse upload = await cloud.uploadFile(
            filePath: controller.img.value, folder: "postPhotos");
        postRepo.tweet(v.text.trim().replaceAll(RegExp(r"\n+"), ""),
            'api/posts', upload.url);
      }
      controller.postTextController.clear();
      controller.img.value = '';

      controller.isWaiting.value = false;
    } on Exception catch (e) {
      print(e);
      controller.isWaiting.value = false;
    }
  }
}

// ignore: camel_case_types
class customPaint extends CustomPainter {
  customPaint({this.progress, this.color});
  double progress = 0.0;
  Color color;
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    var val = progress / 50;
    canvas.drawArc(
        rect,
        0.0,
        6.3,
        false,
        Paint()
          ..color = Colors.black26
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke);

    canvas.drawArc(
        rect,
        0.0,
        val,
        false,
        Paint()
          ..color = color
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
