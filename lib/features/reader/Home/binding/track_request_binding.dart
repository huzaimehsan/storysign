import 'package:get/get.dart';

import 'package:storysign/features/reader/Home/controller/track_request_controller.dart';

class TrackRequestBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackRequestController>(() => TrackRequestController());
  }
}
