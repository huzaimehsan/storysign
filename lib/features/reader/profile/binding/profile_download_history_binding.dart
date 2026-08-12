import 'package:get/get.dart';
import '../controller/profile_download_history_controller.dart';

class ProfileDownloadHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileDownloadHistoryController>(
      () => ProfileDownloadHistoryController(),
    );
  }
}
