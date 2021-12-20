import 'package:get/get.dart';
import 'package:twitter_clone/models/tweets.dart';

class LikeController extends GetxController {
  RxBool isLikeorFollowed = RxBool(null);
  RxBool isRetweeted = RxBool(null);
  RxInt likeOrfollwedCount = RxInt(null);
  RxInt retweetCount = RxInt(null);
  RxList<Reply> replyList = RxList.empty(growable: true);

  addReply(Reply reply) {
    replyList.insert(0, reply);
  }

  fetchReplies(List<Reply> list) {
    replyList.value = list;
  }

  likeHandler() {
    if (isLikeorFollowed.value) {
      isLikeorFollowed.value = false;
      likeOrfollwedCount.value--;
    } else {
      isLikeorFollowed.value = true;
      likeOrfollwedCount.value++;
    }
  }

  retweetHandler() {
    if (isRetweeted.value) {
      isRetweeted.value = false;
      retweetCount.value--;
    } else {
      isRetweeted.value = true;
      retweetCount.value++;
    }
  }

  initializValues(List likevalue, List retweetvalue, String id) {
    likeOrfollwedCount.value = likevalue.length;
    retweetCount.value = retweetvalue.length;
    isLikeorFollowed.value = fetchLIkeandretweets(likevalue, id);
    isRetweeted.value = fetchLIkeandretweets(retweetvalue, id);
  }

  fetchLIkeandretweets(List value, String id) {
    var isLikeorRtweeted;
    if (value.length == 0 || value == null) {
      isLikeorRtweeted = false;
    } else {
      var isRetweeted = value.any((element) => element == id);
      isLikeorRtweeted = isRetweeted;
    }
    return isLikeorRtweeted;
  }
}

class LikeBinding extends Bindings {
  @override
  void dependencies() {
    Get.create(() => LikeController());
  }
}
