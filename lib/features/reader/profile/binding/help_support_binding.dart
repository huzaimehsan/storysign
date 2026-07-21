import 'package:get/get.dart';
import '../controller/help_support_controller.dart';

class HelpSupportBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpSupportController>(() => HelpSupportController());
  }
}
