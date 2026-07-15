import 'package:get/get.dart';
import '../../Home/controller/home_controller.dart';
import '../../Home/controller/request_detail_controller.dart';
import '../controller/search_page_controller.dart';

class SearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchPageController>(() => SearchPageController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<AuthorDetailController>(() => AuthorDetailController());
  }
}
