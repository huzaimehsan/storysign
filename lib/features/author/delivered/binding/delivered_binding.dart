import 'package:get/get.dart';
import '../controller/delivered_controller.dart';

class DeliveredBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveredController>(() => DeliveredController());
  }
}
