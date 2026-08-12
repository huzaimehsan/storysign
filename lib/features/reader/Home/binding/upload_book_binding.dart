import 'package:get/get.dart';


import '../controller/upload_book_controller.dart';


class UploadBookBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadBookController>(() => UploadBookController());

  }
}
