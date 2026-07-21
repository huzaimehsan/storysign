import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';
import '../model/profile_model.dart';

class ProfileScreenController extends GetxController {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();
  Rxn<LibraryStatsModel> libraryStats = Rxn<LibraryStatsModel>();
  RxBool isStatsLoading = false.obs;
  RxList<BookItem> bookList = <BookItem>[].obs;
  RxBool isbookLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getProfile();
    fetchLibraryStats();
    downloadHistory();
  }

  Future<void> refreshRequests() async {
    await Future.wait([
      getProfile(),
      fetchLibraryStats(),
      downloadHistory(),
    ]);
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
          profileModel.value = ProfileModel.fromJson(
            Map<String, dynamic>.from(decodedBody),
          );
        } else {
          errorMessage.value = 'Invalid profile response';
          Utils.showToast(errorMessage.value, true);
        }
      } else {
        final responseBody = jsonDecode(response.body);
        final message = responseBody['message']?.toString() ?? 'Failed to load profile';
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

  Future<void> fetchLibraryStats() async {
    try {
      isStatsLoading.value = true;
      final response = await BaseService().baseGetAPI(ApiEndPoints.libraryStats);
      if (response != null) {
        libraryStats.value = LibraryStatsModel.fromJson(response);
      }
    } catch (e) {
      debugPrint('ProfileScreenController fetchLibraryStats error: $e');
    } finally {
      isStatsLoading.value = false;
    }
  }

  Future<void> downloadHistory() async {
    try {
      isbookLoading.value = true;
      final token = SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
      final uri = Uri.parse('${BaseService().baseURL}${ApiEndPoints.bookHistory}');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> decodedBody = jsonDecode(response.body);
        final data = BookResponse.fromJson(decodedBody);
        bookList.assignAll(data.items);
      } else {
        Utils.showToast('Failed to load history', true);
      }
    } catch (e) {
      debugPrint('ProfileScreenController downloadHistory error: $e');
      Utils.showToast('Something went wrong', true);
    } finally {
      isbookLoading.value = false;
    }
  }
}
