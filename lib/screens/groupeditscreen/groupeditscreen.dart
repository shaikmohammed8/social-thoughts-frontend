import 'dart:io';
import 'dart:ui';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/controller/ChatController.dart';
import 'package:twitter_clone/credeantials/cloudainary.dart' as cd;
import 'package:twitter_clone/models/chat.dart';
import 'package:twitter_clone/repositories/chatRepository.dart';
import 'package:twitter_clone/utils/utlis.dart';

// ignore: must_be_immutable
class GroupEditScreen extends StatelessWidget {
  var cloud = Cloudinary(
      cd.Cloudinary.API_KEY, cd.Cloudinary.API_SECRET, cd.Cloudinary.API_ENV);

  final ImagePicker _picker = ImagePicker();
  GroupEditScreen({Key key}) : super(key: key);
  var chatController = Get.find<ChatController>();
  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Group",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(alignment: Alignment.center, children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AspectRatio(
                      aspectRatio: 13 / 9,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 4),
                        child: ObxValue(
                          (s) => s.value == ''
                              ? image(
                                  args(context)['photo'],
                                )
                              : ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                      Colors.black26, BlendMode.darken),
                                  child: Image.file(
                                    File(s.value),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          chatController.img,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        )),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: ObxValue(
                        (s) => s.value == ''
                            ? image(
                                args(context)['photo'],
                              )
                            : Image.file(
                                File(s.value),
                                fit: BoxFit.cover,
                              ),
                        chatController.img,
                      ),
                    ),
                  ),
                  Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(
                          CupertinoIcons.photo_camera_solid,
                          color: Colors.white,
                        ),
                        onPressed: () => openSnackBar(context),
                      )),
                  Positioned(
                    bottom: 18,
                    child: ValueListenableBuilder(
                      valueListenable: controller,
                      builder: (BuildContext context, value, Widget child) {
                        return Text(
                          value.text.trim().isEmpty
                              ? args(context)['name'].toString()
                              : value.text.trim(),
                          style: Theme.of(context).textTheme.subtitle1,
                        );
                      },
                    ),
                  )
                ]),
                Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Theme.of(context).dividerColor,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.only(
                        right: 16, left: 16, top: 25, bottom: 16),
                    child: TextField(
                      controller: controller,
                      style: Theme.of(context).textTheme.caption,
                      textAlignVertical: TextAlignVertical.center,
                      maxLength: 25,
                      decoration: InputDecoration(
                        isDense: true,
                        counterText: '',
                        hintText: 'Enter group name',
                      ),
                    )),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (BuildContext context, value, Widget child) => Obx(
                    () => AnimatedContainer(
                      height: 45,
                      width: chatController.isWaiting.value ? 60 : 200,
                      duration: Duration(milliseconds: 200),
                      child: ElevatedButton(
                        onPressed: value.text.trim().isEmpty
                            ? null
                            : () async {
                                chatController.isWaiting.value = true;

                                if (chatController.img.value == '') {
                                  ChatRepository().chat(
                                      Chat(
                                          chatName: controller.text.trim(),
                                          isGroupChat: true,
                                          users: chatController.list),
                                      "api/chat");
                                } else {
                                  try {
                                    var upload = await cloud.uploadFile(
                                        filePath: chatController.img.value,
                                        folder: "groupPhoto");
                                    ChatRepository().chat(
                                        Chat(
                                            chatName: controller.text.trim(),
                                            photo: upload.url,
                                            isGroupChat: true,
                                            users: chatController.list),
                                        "api/chat");
                                  } on Exception catch (e) {
                                    print(e);
                                  }
                                }
                                chatController.isWaiting.value = false;
                                controller.clear();
                              },
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 200),
                          transitionBuilder: (w, a) => ScaleTransition(
                            scale: a,
                            child: w,
                          ),
                          child: chatController.isWaiting.value
                              ? SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : Text('Create group'),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(200, 45),
                            onPrimary: Colors.white,
                            primary: Theme.of(context).primaryColor,
                            textStyle: TextStyle(
                              color: Colors.white,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  openSnackBar(context) {
    Get.bottomSheet(Container(
      decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 8),
            width: 50,
            height: 7,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).dividerColor),
          ),
          ListTile(
              onTap: openCamera,
              leading: Icon(CupertinoIcons.photo_camera_solid,
                  color: Theme.of(context).iconTheme.color),
              title: Text(
                'Camera',
                style: Theme.of(context).textTheme.caption,
              )),
          ListTile(
              onTap: openGallery,
              leading: Icon(CupertinoIcons.photo_fill,
                  color: Theme.of(context).iconTheme.color),
              title: Text(
                'Gallery',
                style: Theme.of(context).textTheme.caption,
              )),
          ListTile(
              onTap: () {
                chatController.img.value = '';
              },
              leading: Icon(CupertinoIcons.delete_solid,
                  color: Theme.of(context).iconTheme.color),
              title: Text(
                'remove photo',
                style: Theme.of(context).textTheme.caption,
              ))
        ],
      ),
    ));
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
        aspectRatio: CropAspectRatio(ratioX: 13, ratioY: 9),
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
      chatController.img.value = croppedFile.path;
    }
  }

  Map args(context) {
    return ModalRoute.of(context).settings.arguments;
  }
}
