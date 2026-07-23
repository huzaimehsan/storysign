import 'package:get/get.dart';
import '../controller/all_request_controller.dart';
import '../controller/add_message_controller.dart';
import '../controller/draw_signature_controller.dart';
import '../controller/ebook_preview_controller.dart';
import '../controller/place_signature_controller.dart';
import '../controller/request_detail_controller.dart';
import '../controller/final_review_controller.dart';

class AddMessageBinding implements Bindings {
  @override
  void dependencies() {

    Get.lazyPut<AddMessageController>(() => AddMessageController());

  }
}

