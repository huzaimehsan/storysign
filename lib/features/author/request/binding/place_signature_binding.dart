import 'package:get/get.dart';
import 'package:storysign/features/author/request/controller/place_signature_controller.dart';

class PlaceSignatureBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlaceSignatureController>(() => PlaceSignatureController());
  }
}
