import 'package:get/get.dart';
import 'package:storysign/features/reader/Home/controller/payment_controller.dart';
import 'package:storysign/features/reader/Home/controller/tracking_controller.dart';

class TrackingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackingController>(() => TrackingController());
  }
}
