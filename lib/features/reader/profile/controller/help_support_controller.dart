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


  List<FaqModel> _originalFaqList = [];


  RxList<FaqModel> faqList = <FaqModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getHelpSupportData();
    getFaqs();


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
      final response = await baseService.baseGetAPI(ApiEndPoints.helpSupport,loading: false);

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
      final Map<String, dynamic> response = await baseService.baseGetAPI(ApiEndPoints.faqs,loading: false);

      if (response['success'] == true) {
        List<dynamic> list = response['data'] ?? [];


        _originalFaqList = list
            .map((item) => FaqModel.fromJson(item as Map<String, dynamic>))
            .toList();


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