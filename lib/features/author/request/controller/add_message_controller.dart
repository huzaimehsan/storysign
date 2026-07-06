import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMessageController extends GetxController {
  final TextEditingController messageController = TextEditingController(
    text: "Through Okonkwo’s journey, I explored themes of identity, pride, family, and the fear of losing one’s roots. My hope was to create a story that not only tells the life of one man.",
  );

  final RxInt charCount = 0.obs;
  final int maxLimit = 300;

  @override
  void onInit() {
    super.onInit();
    charCount.value = messageController.text.length;
    messageController.addListener(() {
      charCount.value = messageController.text.length;
    });
  }

  void saveMessage(BuildContext context) {
    Navigator.of(context).pushNamed('/authorFinalReview');
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
