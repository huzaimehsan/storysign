import 'package:get/get.dart';
import '../controller/library_controller.dart';

class ReaderLibraryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReaderController>(() => ReaderController());
  }
}
