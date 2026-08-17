import 'package:get/get.dart';
import 'package:storysign/features/reader/Home/controller/payment_controller.dart';

class PaymentBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentController>(() => PaymentController());
  }
}
