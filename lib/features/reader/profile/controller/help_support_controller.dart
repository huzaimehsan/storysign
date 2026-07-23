import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/utility.dart';
import '../model/profile_screen_model.dart';

class HelpSupportController extends GetxController {
  RxBool isFaqsLoading = false.obs;
  RxString searchQuery = ''.obs;
  Rxn<AuthorHelpSupportModel> supportData = Rxn<AuthorHelpSupportModel>();

  // 1. Original list jo API se aayegi
  List<FaqModel> _originalFaqList = [];

  // 2. Yeh wo list hai jo UI par display aur filter hogi
  RxList<FaqModel> faqList = <FaqModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getHelpSupportData();
    getFaqs();

    // 3. searchQuery jab bhi change hogi, yeh list ko filter karega
    ever(searchQuery, (_) {
      _filterFaqs(searchQuery.value);
    });
  }

  Future<void> refreshHelpSupport() async {
    await getHelpSupportData();
    await getFaqs();
  }

  Future<void> getHelpSupportData() async {
    try {
      final BaseService baseService = BaseService();
      final response = await baseService.baseGetAPI(ApiEndPoints.helpSupport);

      if (response['success'] == true) {
        supportData.value = AuthorHelpSupportModel.fromJson(response);
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

        // 4. Data ko original list mein save karein
        _originalFaqList = list
            .map((item) => FaqModel.fromJson(item as Map<String, dynamic>))
            .toList();

        // 5. Initial load par filter function call karein taaki view update ho jaye
        _filterFaqs(searchQuery.value);

      } else {
        Utils.showToast(response['message'] ?? "Error", true);
      }
    } catch (e) {
      debugPrint("HelpSupportController getFaqs error: $e");
    } finally {
      isFaqsLoading.value = false;
    }
  }

  // 6. Filtering logic
  void _filterFaqs(String query) {
    if (query.isEmpty) {
      faqList.assignAll(_originalFaqList);
    } else {
      faqList.assignAll(
        _originalFaqList.where((faq) =>
        faq.question.toLowerCase().contains(query.toLowerCase()) ||
            faq.answer.toLowerCase().contains(query.toLowerCase())
        ).toList(),
      );
    }
  }
}