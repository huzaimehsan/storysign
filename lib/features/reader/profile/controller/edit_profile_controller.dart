import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';
import '../../../../widgets/image_picker.dart';
import '../model/profile_model.dart';

import '../../Home/controller/home_controller.dart';
import 'profile_controller.dart';

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
      final prefs = SharedPreferencesMethod.storage;
      final token = prefs.getString(LocalDBKeys.TOKEN) ?? '';

      if (token.isEmpty) {
        Utils.showToast('Please login again', true);
        return;
      }

      final uri = Uri.parse('${BaseService().baseURL}${ApiEndPoints.profile}');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final dynamic decodedBody = jsonDecode(response.body);
        if (decodedBody is Map) {
          profileModel.value = ProfileModel.fromJson(Map<String, dynamic>.from(decodedBody));
          nameUpdateController.text = profileModel.value?.fullName ?? '';
          emailUpdateController.text = profileModel.value?.email ?? '';
          clearEditProfile();
        } else {
          Utils.showToast('Invalid profile response', true);
        }
      } else {
        Utils.showToast('Failed to load profile', true);
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
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse('${BaseService().baseURL}${ApiEndPoints.editProfile}'),
      );

      var token = await SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN);
      request.headers.addAll({'Authorization': 'Bearer $token'});

      request.fields['fullName'] = nameUpdateController.text.trim();
      request.fields['email'] = emailUpdateController.text.trim();

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('profilePicture', imageFile.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Utils.showToast('Profile updated successfully', false);
        clearImageProfile();
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().getProfile();
        }
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().loadUserProfile();
        }
        Get.back();
      } else {
        Utils.showToast('Update failed: ${response.statusCode}', true);
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


  void clearImageProfile(){

    profileImage.value = null;
    selectedImage.value = null;
  }
}
