import 'package:get/get.dart';
import '../controller/view_all_books_controller.dart';

class ViewAllBooksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewAllBooksController>(
      () => ViewAllBooksController(),
    );
  }
}
