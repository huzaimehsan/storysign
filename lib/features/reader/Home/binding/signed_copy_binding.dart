import 'package:get/get.dart';
import 'package:storysign/features/reader/Home/controller/signed_copy_controller.dart';

class SignedCopyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignedCopyController>(() => SignedCopyController());
  }
}
