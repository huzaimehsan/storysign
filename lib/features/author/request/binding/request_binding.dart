import 'package:get/get.dart';
import '../controller/all_request_controller.dart';

import '../controller/draw_signature_controller.dart';
import '../controller/ebook_preview_controller.dart';
import '../controller/place_signature_controller.dart';
import '../controller/request_detail_controller.dart';
import '../controller/final_review_controller.dart';

class RequestBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllRequestController>(() => AllRequestController(),fenix: true);
    Get.lazyPut<EbookPreviewController>(() => EbookPreviewController());
    Get.lazyPut<DrawSignatureController>(() => DrawSignatureController());
    Get.lazyPut<PlaceSignatureController>(() => PlaceSignatureController());

     Get.lazyPut<RequestDetailController>(() => RequestDetailController());
     Get.lazyPut<FinalReviewController>(() => FinalReviewController());
  }
}

