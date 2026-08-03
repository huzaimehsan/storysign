import 'package:get/get.dart';
import '../controller/library_detail_controller.dart';

class ReaderLibraryDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReaderLibraryDetailController>(() => ReaderLibraryDetailController());
  }
}
