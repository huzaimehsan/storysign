import 'package:get/get.dart';
import '../controller/stripe_payment_controller.dart';

class StripePaymentBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StripePaymentController>(() => StripePaymentController());
  }
}
