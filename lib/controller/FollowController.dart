import 'package:get/get.dart';

class FollowController extends GetxController {
  RxBool isFollowed = RxBool(null);
  RxInt followCount = RxInt(null);

  followhandler() {
    if (isFollowed.value) {
      isFollowed.value = false;
      followCount.value--;
    } else {
      isFollowed.value = true;
      followCount.value++;
    }
  }

  intializFollowers(List followlist, String id) {
    followCount.value = followlist.length;
    isFollowed.value = fetchfollowers(followlist, id);
  }

  fetchfollowers(List value, String id) {
    var isFollow;
    if (value.length == 0 || value == null) {
      isFollow = false;
    } else {
      var isRetweeted = value.any((element) => element == id);
      isFollow = isRetweeted;
    }
    return isFollow;
  }
}

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.create(() => FollowController());
  }
}
