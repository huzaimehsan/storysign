import 'package:get/get.dart';
import 'package:storysign/features/author/delivered/controller/delivered_controller.dart';
import 'package:storysign/features/author/request/controller/all_request_controller.dart';
import 'package:storysign/features/author/request/controller/draw_signature_controller.dart';
import 'package:storysign/features/author/request/controller/ebook_preview_controller.dart';
import 'package:storysign/features/author/request/controller/place_signature_controller.dart';
import 'package:storysign/features/author/request/controller/add_message_controller.dart';
import 'package:storysign/features/author/home/controller/home_controller.dart';
import 'package:storysign/features/author/request/controller/request_detail_controller.dart';
import 'package:storysign/features/reader/profile/controller/profile_controller.dart';

import '../../../reader/profile/controller/profile_screen_controller.dart';
import '../controller/author_bottom_nav_controller.dart';

class AuthorBottomNavBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthorBottomNavController>(() => AuthorBottomNavController());
    Get.lazyPut<AuthorHomeController>(() => AuthorHomeController());
    Get.lazyPut<AllRequestController>(() => AllRequestController());
    Get.lazyPut<EbookPreviewController>(() => EbookPreviewController());

    Get.lazyPut<DrawSignatureController>(() => DrawSignatureController());
    Get.lazyPut<PlaceSignatureController>(() => PlaceSignatureController());
    Get.lazyPut<AddMessageController>(() => AddMessageController());
    Get.lazyPut<DeliveredController>(() => DeliveredController());
    Get.lazyPut<RequestDetailController>(() => RequestDetailController());


    Get.lazyPut<ProfileScreenController>(() => ProfileScreenController());
  }
}
