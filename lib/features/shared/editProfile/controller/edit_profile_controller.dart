import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:storysign/features/reader/profile/controller/profile_screen_controller.dart';
import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';
import '../../../../widgets/image_picker.dart';
import '../../../reader/profile/model/profile_screen_model.dart';

import '../../../reader/Home/controller/home_controller.dart';


class EditProfileController extends GetxController {
  final nameUpdateController = TextEditingController();
  final emailUpdateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;
  Rxn<File> profileImage = Rxn<File>();
  Rxn<File> selectedImage = Rxn<File>();
  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> pickImage(BuildContext context) async {
    final File? file = await MediaPickerService().pickMedia(context);
    if (file != null) {
      profileImage.value = file;
      selectedImage.value = file;
    }
  }

  Future<void> getProfile() async {
    try {
      isLoading.value = true;
      final response = await BaseService().baseGetAPI(
        ApiEndPoints.profile,
        loading: false,
      );

      if (response['success'] == true) {
        final data = Map<String, dynamic>.from(response)
          ..remove('success')
          ..remove('statusCode');

        profileModel.value = ProfileModel.fromJson(data);
        nameUpdateController.text = profileModel.value?.fullName ?? '';
        emailUpdateController.text = profileModel.value?.email ?? '';
        clearEditProfile();
      } else {
        Utils.showToast(response['message'] ?? 'Failed to load profile', true);
      }
    } catch (e) {
      Utils.showToast('Something went wrong while loading profile', true);
      debugPrint('EditProfileController getProfile error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfileWithImage(File? imageFile) async {
    isLoading.value = true;

    try {
      final request = http.MultipartRequest(
        'PATCH',
        Uri.parse('${BaseService().baseURL}${ApiEndPoints.editProfile}'),
      );

      request.fields['fullName'] = nameUpdateController.text.trim();
      request.fields['email'] = emailUpdateController.text.trim();

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('profilePicture', imageFile.path),
        );
      }

      final response = await BaseService().baseMultipartPatchAPI(
        ApiEndPoints.editProfile,
        request: request,
      );

      if (response['success'] == true) {
        Utils.showToast('Profile updated successfully', false);
        clearImageProfile();
        if (Get.isRegistered<ProfileScreenController>()) {
          Get.find<ProfileScreenController>().getProfile();
        }
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().loadUserProfile();
        }
        Get.back();
      } else {
        Utils.showToast(response['message'] ?? 'Update failed', true);
      }
    } catch (e) {
      debugPrint('EditProfileController updateProfileWithImage error: $e');
      Utils.showToast('Something went wrong', true);
    } finally {
      isLoading.value = false;
    }
  }

  void clearEditProfile() {
    nameUpdateController.clear();
    emailUpdateController.clear();
  }

  void clearImageProfile() {
    profileImage.value = null;
    selectedImage.value = null;
  }
}
