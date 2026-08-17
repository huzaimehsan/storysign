import 'package:get/get.dart';
import 'package:storysign/features/reader/Home/controller/select_author_controller.dart';

class SelectAuthorBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectAuthorController>(() => SelectAuthorController());
  }
}
