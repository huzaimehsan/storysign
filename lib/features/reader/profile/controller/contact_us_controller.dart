import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';

class ContactUsController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;

  Future<void> sendContactForm() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty) {
      Utils.showToast('Please fill all fields', true);
      return;
    }

    try {
      isLoading.value = true;
      final BaseService baseService = BaseService();
      final Map<String, dynamic> body = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'subject': subjectController.text.trim(),
        'message': messageController.text.trim(),
      };

      final response = await baseService.basePostAPI(
        ApiEndPoints.contactUs,
        body,
      );

      if (response['success'] == true) {
        Utils.showToast('Message sent successfully!', false);
        clearContactForm();
        Get.back();
      } else {
        Utils.showToast(response['message'] ?? 'Failed to send', true);
      }
    } catch (e) {
      Utils.showToast('Something went wrong', true);
      debugPrint('ContactUsController error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearContactForm() {
    nameController.clear();
    emailController.clear();
    subjectController.clear();
    messageController.clear();
  }
}
