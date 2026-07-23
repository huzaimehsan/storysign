import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/utility.dart';
import '../../../../widgets/sucess_widget.dart';

class ChangePasswordController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final RxBool isPasswordHidden = true.obs;
  final confirmPasswordController = TextEditingController();
  RxBool isLoading = false.obs;
 final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  Future<void> changePassword() async {
    final String newPassword = newPasswordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();
    final String oldPassword = oldPasswordController.text.trim();

    // Validation
    if (newPassword.length < 8) {
      Utils.showToast('Password must be at least 8 characters', true);
      return;
    }
    if (newPassword != confirmPassword) {
      Utils.showToast('Passwords do not match', true);
      return;
    }

    try {
      final response = await BaseService().basePostAPI(
        ApiEndPoints.changePassword,
        {

          'currentPassword': oldPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );

      if (response['success'] == true) {
        Utils.showToast(
          response['message'] ?? 'Password changed successful',
          false,
        );

        Get.offAllNamed('/login');
        clearNewPasswordFeild();
      }
      // basePostAPI already error toast dikha chuka hai — dobara mat lagao
    } catch (e) {
      debugPrint('resetPassword error: $e');
      Utils.showToast('Something went wrong', true);
    }
  }

  void clearNewPasswordFeild(){
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();

  }

}
