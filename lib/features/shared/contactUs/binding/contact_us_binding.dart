import 'package:get/get.dart';
import '../controller/contact_us_controller.dart';

class ContactUsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactUsController>(() => ContactUsController());
  }
}
