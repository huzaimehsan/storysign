import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/utility.dart';
import '../../../../widgets/sucess_widget.dart';

class ChangePasswordController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  RxBool isLoading = false.obs;

  bool validateInputs() {
    if (oldPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Utils.showToast('Please fill all fields', true);
      return false;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Utils.showToast('Passwords do not match', true);
      return false;
    }

    if (newPasswordController.text.length < 8) {
      Utils.showToast('Password must be at least 8 characters', true);
      return false;
    }

    return true;
  }

  void submitPasswordChange(BuildContext context) {
    if (!validateInputs()) return;

    showSuccessDialog(
      context,
      desc: "Your Autograph Request have been sent Successfully",
      buttonText: "Back To Dashboard",
      ontap: () => Get.offAllNamed('/bottomnav'),
    );
  }
}
