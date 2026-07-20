import 'package:get/get.dart';
import 'package:storysign/features/reader/Home/controller/home_controller.dart';
import 'package:storysign/features/reader/Home/controller/payment_controller.dart';
import 'package:storysign/features/reader/Home/controller/request_detail_controller.dart';


class RequestDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthorDetailController>(() => AuthorDetailController());
  }
}
