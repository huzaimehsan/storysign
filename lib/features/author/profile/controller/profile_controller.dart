import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:storysign/features/author/home/controller/home_controller.dart';
import 'package:storysign/features/author/profile/model/profile_model.dart';

import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../../widgets/image_picker.dart';

class AuthorProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  Rxn<AuthorProfileModel> authorProfile = Rxn<AuthorProfileModel>();
  final authorNameUpdateController = TextEditingController();
  final authorEmailUpdateController = TextEditingController();
  final authorBioUpdateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Rxn<File> authorProfileImage = Rxn<File>();
  Rxn<File> authorSelectedImage = Rxn<File>();

  // Compatibility fields/getters for EditProfile view
  TextEditingController get nameUpdateController => authorNameUpdateController;

  TextEditingController get emailUpdateController =>
      authorEmailUpdateController;

  TextEditingController get bioUpdateController => authorBioUpdateController;

  Rxn<File> get profileImage => authorProfileImage;

  Rxn<File> get selectedImage => authorSelectedImage;

  Rxn<AuthorProfileModel> get profileModel => authorProfile;

  Future<void> pickImage(BuildContext context) async {
    final File? file = await MediaPickerService().pickMedia(context);
    if (file != null) {
      authorProfileImage.value = file;
      authorSelectedImage.value = file;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> refreshRequests() async {
    await Future.wait([getProfile()]);
  }

  Future<void> refreshProfileRequests() async {
    await getProfile();
  }

  Future<void> getProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final prefs = SharedPreferencesMethod.storage;
      final token = prefs.getString(LocalDBKeys.TOKEN) ?? '';

      if (token.isEmpty) {
        errorMessage.value = 'Token not found';
        Utils.showToast('Please login again', true);
        return;
      }

      final uri = Uri.parse(
        '${BaseService().baseURL}${ApiEndPoints.authorProfile}',
      );
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
          authorProfile.value = AuthorProfileModel.fromJson(
            Map<String, dynamic>.from(decodedBody),
          );
          authorNameUpdateController.text = authorProfile.value?.fullName ?? '';
          authorEmailUpdateController.text = authorProfile.value?.email ?? '';
          authorBioUpdateController.text = authorProfile.value?.bio ?? '';
          clearEditProfile();
        } else {
          errorMessage.value = 'Invalid profile response';
          Utils.showToast(errorMessage.value, true);
        }
      } else {
        final responseBody = jsonDecode(response.body);
        final message =
            responseBody['message']?.toString() ?? 'Failed to load profile';
        errorMessage.value = message;
        Utils.showToast(message, true);
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong while loading profile.';
      debugPrint('ProfileScreenController getProfile error: $e');
      Utils.showToast(errorMessage.value, true);
    } finally {
      isLoading.value = false;
    }
  }

  void signOut() {
    final pref = SharedPreferencesMethod.storage;
    print(LocalDBKeys.TOKEN);
    pref.clear();
    Get.offAllNamed('/signin');
  }

  Future<void> updateAuthorProfileWithImage(File? imageFile) async {
    isLoading.value = true;

    try {
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse('${BaseService().baseURL}${ApiEndPoints.authorProfile}'),
      );

      var token = await SharedPreferencesMethod.storage.getString(
        LocalDBKeys.TOKEN,
      );
      request.headers.addAll({'Authorization': 'Bearer $token'});

      request.fields['fullName'] = authorNameUpdateController.text.trim();
      request.fields['email'] = authorEmailUpdateController.text.trim();
      request.fields['bio'] = authorBioUpdateController.text.trim();

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('profilePicture', imageFile.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Utils.showToast('Profile updated successfully', false);

        if (Get.isRegistered<AuthorProfileController>()) {
          Get.find<AuthorProfileController>().getProfile();
        }
        if (Get.isRegistered<AuthorHomeController>()) {
          Get.find<AuthorHomeController>().loadAuthorProfile();
        }

        clearImageProfile();
        clearEditProfile();
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
    authorNameUpdateController.clear();
    authorEmailUpdateController.clear();
    authorBioUpdateController.clear();
  }

  void clearImageProfile() {
    authorProfileImage.value = null;
    authorSelectedImage.value = null;
  }
}
