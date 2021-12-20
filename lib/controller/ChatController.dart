import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:twitter_clone/models/user.dart';

class ChatController extends GetxController {
  var query = ''.obs;
  var isEmpty = true.obs;
  var img = ''.obs;
  var isWaiting = false.obs;
  Uint8List bytes;

  List<User> list = <User>[].obs;

  onSelect(User user) {
    if (list.any((element) => element.id == user.id)) {
      list.removeWhere((element) => element.id == user.id);
    } else {
      list.add(user);
    }
  }
}

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatController());
  }
}
