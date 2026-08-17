import 'package:get/get.dart';
import '../controller/profile_view_all_books_controller.dart';

class ProfileViewAllBooksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileViewAllBooksController>(
      () => ProfileViewAllBooksController(),
    );
  }
}
