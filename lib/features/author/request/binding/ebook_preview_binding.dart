import 'package:get/get.dart';

import '../controller/ebook_preview_controller.dart';

class EbookPreviewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EbookPreviewController>(() => EbookPreviewController());
  }
}
