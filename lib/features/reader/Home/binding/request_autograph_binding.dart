import 'package:get/get.dart';
import 'package:storysign/features/reader/Home/binding/reader_request_detail_binding.dart';
import 'package:storysign/features/reader/Home/controller/home_controller.dart';
import 'package:storysign/features/reader/Home/controller/payment_controller.dart';
import 'package:storysign/features/reader/Home/controller/request_autograph_controller.dart';
import 'package:storysign/features/reader/Home/controller/request_detail_controller.dart';


class RequestAutographBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestAutographController>(() => RequestAutographController());

  }
}
