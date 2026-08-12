import 'package:get/get.dart';
import 'package:storysign/features/author/profile/controller/help_and_support_controller.dart';


class AuthorHelpSupportBinding implements Bindings {
  @override
  void dependencies() {

    Get.lazyPut<AuthorHelpSupportController>(() => AuthorHelpSupportController());
  }



}
