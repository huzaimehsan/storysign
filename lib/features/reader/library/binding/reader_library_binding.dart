import 'package:get/get.dart';
import '../controller/reader/reader_controller.dart';

class ReaderLibraryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReaderController>(() => ReaderController());
  }
}
