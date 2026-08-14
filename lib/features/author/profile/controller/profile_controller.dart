import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storysign/features/author/home/controller/home_controller.dart';
import 'package:storysign/features/author/profile/model/profile_model.dart';

import '../../bottomNav/controller/author_bottom_nav_controller.dart';
import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../../widgets/image_picker.dart';
import '../../../../widgets/sucess_widget.dart';

class AuthorProfileController extends GetxController {
  void popTab() {
    if (Get.isRegistered<AuthorBottomNavController>()) {
      Get.find<AuthorBottomNavController>().popCurrentTab();
    }
  }

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

      final response = await BaseService().baseGetAPI(
        ApiEndPoints.authorProfile,
        loading: false,
      );

      if (response['success'] == true) {
        // response itself is the profile map (spread in baseGetAPI),
        // plus 'success' and 'statusCode' keys mixed in.
        final data = Map<String, dynamic>.from(response)
          ..remove('success')
          ..remove('statusCode');

        authorProfile.value = AuthorProfileModel.fromJson(data);
        authorNameUpdateController.text = authorProfile.value?.fullName ?? '';
        authorEmailUpdateController.text = authorProfile.value?.email ?? '';
        authorBioUpdateController.text = authorProfile.value?.bio ?? '';
        clearEditProfile();
      } else {
        // baseGetAPI already shows a toast on failure, so just store the message.
        errorMessage.value = response['message'] ?? 'Failed to load profile';
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong while loading profile.';
      debugPrint('ProfileScreenController getProfile error: $e');
      Utils.showToast(errorMessage.value, true);
    } finally {
      isLoading.value = false;
    }
  }
void signOut() async {
  final pref = Get.find<SharedPreferences>();

  bool hasSeenOnboarding = pref.getBool(LocalDBKeys.ONBOARDING) ?? false;
  bool hasSeenSplash = pref.getBool('has_seen_splash') ?? false;

  await pref.clear();

  if (hasSeenOnboarding) {
    await pref.setBool(LocalDBKeys.ONBOARDING, true);
  }
  if (hasSeenSplash) {
    await pref.setBool('has_seen_splash', true);
  }

  Get.offAllNamed('/signin');
}
  Future<void> updateAuthorProfileWithImage(File? imageFile) async {
    isLoading.value = true;

    try {
      final request = http.MultipartRequest(
        'PATCH',
        Uri.parse('${BaseService().baseURL}${ApiEndPoints.authorProfile}'),
      );

      request.fields['fullName'] = authorNameUpdateController.text.trim();
      request.fields['email'] = authorEmailUpdateController.text.trim();
      request.fields['bio'] = authorBioUpdateController.text.trim();

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('profilePicture', imageFile.path),
        );
      }

      final response = await BaseService().baseMultipartPatchAPI(
        ApiEndPoints.authorProfile,
        request: request,
      );

      if (response['success'] == true) {
        if (Get.isRegistered<AuthorProfileController>()) {
          Get.find<AuthorProfileController>().getProfile();
        }
        if (Get.isRegistered<AuthorHomeController>()) {
          Get.find<AuthorHomeController>().loadAuthorProfile();
        }

        clearImageProfile();
        clearEditProfile();
        showSuccessDialog(
          Get.context!,
          desc: 'Profile updated successfully',
          buttonText: 'Okay',
          ontap: () {
            Get.back(); // close dialog
            Get.back(); // go back to profile
          },
        );
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
    authorNameUpdateController.clear();
    authorEmailUpdateController.clear();
    authorBioUpdateController.clear();
  }

  void clearImageProfile() {
    authorProfileImage.value = null;
    authorSelectedImage.value = null;
  }
}
