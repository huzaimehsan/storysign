import 'package:get/get.dart';
import 'package:storysign/features/author/profile/controller/profile_controller.dart';

import '../controller/help_and_support_controller.dart';

class AuthorProfileBinding implements Bindings {
  @override
  void dependencies() {

    Get.lazyPut<AuthorProfileController>(() => AuthorProfileController());
    Get.lazyPut<AuthorHelpSupportController>(() => AuthorHelpSupportController());

    }



}
