import 'package:get/get.dart';

import '../controller/add_message_controller.dart';


class AddMessageBinding implements Bindings {
  @override
  void dependencies() {

    Get.lazyPut<AddMessageController>(() => AddMessageController());

  }
}

