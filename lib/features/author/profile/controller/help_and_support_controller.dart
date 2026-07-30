import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/utility.dart';
import '../../../reader/profile/model/profile_screen_model.dart';
import '../model/help_support_model.dart' hide AuthorHelpSupportModel;
import '../model/profile_model.dart';

class AuthorHelpSupportController extends GetxController {
  RxBool isFaqsLoading = false.obs;
  RxString searchQuery = ''.obs;
  Rxn<AuthorHelpSupportModel> supportAuthorData = Rxn<AuthorHelpSupportModel>();


  List<AuthorFaqModel> _originalFaqAuthorList = [];


  RxList<AuthorFaqModel> faqAuthorList = <AuthorFaqModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAuthorHelpSupportData();
    getAuthorFaqs();


    ever(searchQuery, (_) {
      _filterAuthorFaqs(searchQuery.value);
    });
  }

  Future<void> refreshHelpSupport() async {
    await getAuthorHelpSupportData();
    await getAuthorFaqs();
  }

  Future<void> getAuthorHelpSupportData() async {
    try {
      final BaseService baseService = BaseService();
      final response = await baseService.baseGetAPI(ApiEndPoints.authorHelpSupport);

      if (response['success'] == true) {
        supportAuthorData.value = AuthorHelpSupportModel.fromJson(response);
      } else {
        Utils.showToast(response['message'] ?? "Failed to load support data", true);
      }
    } catch (e) {
      Utils.showToast("Unexpected error occurred", true);
      debugPrint("HelpSupportController error: $e");
    }
  }

  Future<void> getAuthorFaqs() async {
    try {
      isFaqsLoading.value = true;
      final BaseService baseService = BaseService();
      final Map<String, dynamic> response = await baseService.baseGetAPI(ApiEndPoints.authorFaqs);

      if (response['success'] == true) {
        List<dynamic> list = response['data'] ?? [];

        // 4. Original list mein data store karein
        _originalFaqAuthorList = list
            .map((item) => AuthorFaqModel.fromJson(item as Map<String, dynamic>))
            .toList();

        // 5. Initial load par filter call karein
        _filterAuthorFaqs(searchQuery.value);

      } else {
        Utils.showToast(response['message'] ?? "Error", true);
      }
    } catch (e) {
      debugPrint("HelpSupportController getFaqs error: $e");
    } finally {
      isFaqsLoading.value = false;
    }
  }

  // 6. Filtering logic for Author FAQs
  void _filterAuthorFaqs(String query) {
    if (query.isEmpty) {
      faqAuthorList.assignAll(_originalFaqAuthorList);
    } else {
      faqAuthorList.assignAll(
        _originalFaqAuthorList.where((faq) =>
        faq.question.toLowerCase().contains(query.toLowerCase()) ||
            faq.answer.toLowerCase().contains(query.toLowerCase())
        ).toList(),
      );
    }
  }
}