import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/utility.dart';
import '../model/profile_model.dart';

class HelpSupportController extends GetxController {
  RxBool isFaqsLoading = false.obs;
  RxString searchQuery = ''.obs;
  Rxn<AuthorHelpSupportModel> supportData = Rxn<AuthorHelpSupportModel>();
  RxList<FaqModel> faqList = <FaqModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getHelpSupportData();
    getFaqs();
  }

  Future<void> getHelpSupportData() async {
    try {
      final BaseService baseService = BaseService();
      final response = await baseService.baseGetAPI(ApiEndPoints.helpSupport);

      if (response['success'] == true) {
        supportData.value = AuthorHelpSupportModel.fromJson(response);
        print('sucess');
      } else {
        Utils.showToast(response['message'] ?? "Failed to load support data", true);
      }
    } catch (e) {
      Utils.showToast("Unexpected error occurred", true);
      debugPrint("HelpSupportController error: $e");
    }
  }

  Future<void> getFaqs() async {
    try {
      isFaqsLoading.value = true;
      final BaseService baseService = BaseService();
      final Map<String, dynamic> response = await baseService.baseGetAPI(ApiEndPoints.faqs);

      if (response['success'] == true) {
        List<dynamic> list = response['data'] ?? [];
        faqList.value = list
            .map((item) => FaqModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        Utils.showToast(response['message'] ?? "Error", true);
      }
    } catch (e) {
      debugPrint("HelpSupportController getFaqs error: $e");
    } finally {
      isFaqsLoading.value = false;
    }
  }
}
