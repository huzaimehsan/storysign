import 'package:get/get.dart';
import '../controller/help_support_controller.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpAndSupportController>(() => HelpAndSupportController());
  }
}
