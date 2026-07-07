import 'package:get/get.dart';
import '../controller/author_home_controller.dart';

class AuthorHomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthorHomeController>(() => AuthorHomeController());
  }
}
