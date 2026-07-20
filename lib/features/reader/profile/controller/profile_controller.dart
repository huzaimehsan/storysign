import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';
import '../../../../widgets/image_picker.dart';
import '../model/profile_model.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  final nameUpdateController = TextEditingController();
  final emailUpdateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();
  RxBool isLoading = false.obs; // Data load ke liye
  RxBool isFaqsLoading = false.obs; // FAQ load ke liye

  var profileImage = Rxn<File>();

  // Original data
  final List<Map<String, String>> allFaqs = [
    {
      'title': '1. What is StorySign?',
      'description': 'StorySign is a digital platform...',
    },
    {
      'title': '2. How does StorySign work?',
      'description': 'Readers can browse author profiles...',
    },
    {
      'title': '3. Can readers upload their own ebooks?',
      'description': 'Yes. Readers can upload...',
    },
    {
      'title': '4. Do authors need a subscription plan?',
      'description': 'Yes. Authors must subscribe...',
    },
    {
      'title': '5. What subscription plans are available?',
      'description': 'Starter Plan – 25 signatures...',
    },
    {
      'title': '6. Can authors reject signature requests?',
      'description': 'Yes. Authors can either...',
    },
    {
      'title': '7. What payment methods are supported?',
      'description': 'StorySign supports secure...',
    },
  ];

  // Search query state
  var searchQuery = ''.obs;

  List<Map<String, String>> get filteredFaqs {
    if (searchQuery.value.isEmpty) {
      return allFaqs;
    } else {
      return allFaqs
          .where(
            (faq) =>
                faq['title']!.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                faq['description']!.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ),
          )
          .toList();
    }
  }

  Future<void> pickImage(BuildContext context) async {
    final File? file = await MediaPickerService().pickMedia(context);
    if (file != null) {
      profileImage.value = file;
    }
  }

  // Model ko store karne ke liye observable variable
  // Explicitly initialize karein
  Rxn<HelpSupportModel> supportData = Rxn<HelpSupportModel>(null);

  @override
  void onInit() {
    super.onInit();
    getHelpSupportData();
    getFaqs();
    getProfile();
    fetchLibraryStats();
    downloadHistory();
  }


  Future<void> refreshRequests() async {
    // Apni wahi API call yahan dobara call karein jo data fetch karti hai
    getProfile();
    fetchLibraryStats();
    downloadHistory();
  }

  Future<void> getHelpSupportData() async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Loading...');

      final BaseService baseService = BaseService();

      // ApiEndPoints.getHelpSupport (yahan apna endpoint define kar dein)
      final response = await baseService.baseGetAPI(ApiEndPoints.helpSupport);

      if (response['success'] == true) {
        // API response se data map karein
        supportData.value = HelpSupportModel.fromJson(response);
      } else {
        Utils.showToast(response['message'] ?? "Failed to load data", true);
      }
    } catch (e) {
      Utils.showToast("Unexpected error occurred", true);
      debugPrint("ERROR DETAILS: $e"); // Ye console mein asali error dikhayega
      Utils.showToast("Error: ${e.toString()}", true);
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  Future<void> sendContactForm() async {
    // Basic Validation
    if (nameController.text.isEmpty || emailController.text.isEmpty) {
      Utils.showToast("Please fill all fields", true);
      return;
    }

    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Sending...');

      final BaseService baseService = BaseService();

      // JSON body jo aapne di hai
      final Map<String, dynamic> body = {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "subject": subjectController.text.trim(),
        "message": messageController.text.trim(),
      };

      // API Call (POST)
      // ApiEndPoints.contactUs (yahan apna contact endpoint daalein)
      final response = await baseService.basePostAPI(
        ApiEndPoints.contactUs,
        body,
      );

      if (response['success'] == true) {
        Utils.showToast("Message sent successfully!", false);

        clearContactForm();
        Get.back(); // Form screen se wapas chale jayenge
      } else {
        Utils.showToast(response['message'] ?? "Failed to send", true);
      }
    } catch (e) {
      Utils.showToast("Something went wrong", true);
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  void clearContactForm() {
    nameController.clear();
    emailController.clear();
    subjectController.clear();
    messageController.clear();
  }

  RxList<FaqModel> faqList = <FaqModel>[].obs;

  Future<void> getFaqs() async {
    try {
      isFaqsLoading.value = true;
      final BaseService baseService = BaseService();

      final Map<String, dynamic> response = await baseService.baseGetAPI(
        ApiEndPoints.faqs,
      );

      if (response['success'] == true) {
        // Ab hum response['data'] se list nikal sakte hain
        List<dynamic> list = response['data'] ?? [];

        faqList.value = list
            .map((item) => FaqModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        Utils.showToast(response['message'] ?? "Error", true);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isFaqsLoading.value = false;
    }
  }

  // 1. RxList ki jagah Rxn<ProfileModel> use karein (kyunke API sirf 1 profile object de rahi hai)
  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();
  RxBool isProfileLoading = false.obs; // Isay bhi define karna hoga
  RxString errorMessage = ''.obs;

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
          // 2. Yahan profileModel.value mein object assign karein
          profileModel.value = ProfileModel.fromJson(
            Map<String, dynamic>.from(decodedBody),
          );
          debugPrint(
            'Success! Profile loaded for: ${profileModel.value?.email}',
          );
        } else {
          errorMessage.value = 'Invalid profile response';
          Utils.showToast(errorMessage.value, true);
        }
      } else {
        String message = 'Failed to load profile';
        try {
          final responseBody = jsonDecode(response.body);
          message = responseBody['message']?.toString() ?? message;
        } catch (_) {}
        errorMessage.value = message;
        Utils.showToast(message, true);
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong while loading profile: $e';
      debugPrint('ProfileController getProfile error: $e');
      Utils.showToast(errorMessage.value, true);
    } finally {
      isLoading.value = false;
    }
  }

  var selectedImage = Rxn<File>();

  Future<void> updateProfileWithImage(File? imageFile) async {
    isLoading.value = true;

    try {
      // 1. Multipart request banayein
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse('${BaseService().baseURL}${ApiEndPoints.editProfile}'),
      );

      // 2. Headers add karein
      var token = await SharedPreferencesMethod.storage.getString(
        LocalDBKeys.TOKEN,
      );
      request.headers.addAll({'Authorization': 'Bearer $token'});

      // 3. Text fields add karein
      request.fields['fullName'] = nameUpdateController.text.trim();
      request.fields['email'] = emailUpdateController.text.trim();

      // 4. Agar image hai toh file add karein
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('profilePicture', imageFile.path),
        );
      }

      // 5. Request bhejein
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Utils.showToast("Profile updated successfully", false);
        clearEditProfile();
        Get.back();
      } else {
        Utils.showToast("Update failed: ${response.statusCode}", true);
      }
    } catch (e) {
      debugPrint("Error: $e");
      Utils.showToast("Something went wrong", true);
    } finally {
      isLoading.value = false;
    }
  }

  void clearEditProfile() {
    nameUpdateController.clear();
    emailUpdateController.clear();
  }

  // Library Statistics Model (Agar aap model banana chahein)
  // Controller mein
  var libraryStats = Rxn<LibraryStatsModel>();
  RxBool isStatsLoading = false.obs;

  Future<void> fetchLibraryStats() async {
    try {
      isStatsLoading.value = true;

      final response = await BaseService().baseGetAPI(
        ApiEndPoints.libraryStats,
      );

      // Agar response direct data object hai:
      if (response != null) {
        libraryStats.value = LibraryStatsModel.fromJson(response);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isStatsLoading.value = false;
    }
  }

  // Controller mein ye list define karein
  var bookList = <BookItem>[].obs;
  var isbookLoading = false.obs;

  Future<void> downloadHistory() async {
    try {
      isbookLoading.value = true;
      final token =
          SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';

      final uri = Uri.parse(
        '${BaseService().baseURL}${ApiEndPoints.bookHistory}',
      );
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("DEBUG: Status Code: ${response.statusCode}");
      print("DEBUG: Response Body: ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> decodedBody = jsonDecode(response.body);
        print("API DATA: $decodedBody");

        // Yahan BookResponse model use karein
        BookResponse data = BookResponse.fromJson(decodedBody);
        print("ITEMS COUNT: ${data.items.length}");

        bookList.assignAll(data.items); // List update ho gayi

        debugPrint('Success! Books loaded: ${bookList.length}');
      } else {
        Utils.showToast('Failed to load history', true);
      }
    } catch (e) {
      debugPrint('Error: $e');
      Utils.showToast('Something went wrong', true);
    } finally {
      isbookLoading.value = false;
    }
  }
}
