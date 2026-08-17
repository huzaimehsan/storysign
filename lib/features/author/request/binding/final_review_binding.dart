import 'package:get/get.dart';

import '../controller/final_review_controller.dart';

class AuthorFinalReviewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinalReviewController>(() => FinalReviewController());
  }
}
