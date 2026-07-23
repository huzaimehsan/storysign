import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:storysign/features/reader/profile/model/recently_signed_book_model.dart';
import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';
import '../model/profile_screen_model.dart';

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
    fetchMyBooks();
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

      final response = await BaseService().baseGetAPI(ApiEndPoints.profile);

      if (response['success'] == true) {
        // baseGetAPI Map response ko spread karke deta hai (...jsonData)
        profileModel.value = ProfileModel.fromJson(response);
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to load profile';
        // baseGetAPI already toast dikha chuka hai — dobara mat lagao
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

      final response = await BaseService().baseGetAPI(ApiEndPoints.bookHistory);

      if (response['success'] == true) {

        final data = BookResponse.fromJson(response);
        bookList.assignAll(data.items);
      }

    } catch (e) {
      debugPrint('ProfileScreenController downloadHistory error: $e');
      Utils.showToast('Something went wrong', true);
    } finally {
      isbookLoading.value = false;
    }
  }

  void signOut(){

    final pref = SharedPreferencesMethod.storage;
    print(LocalDBKeys.TOKEN);
    pref.clear();
    Get.toNamed('/signin');
  }
  final RxList<MyProfileBookModel> books = <MyProfileBookModel>[].obs;
  final RxBool isBookLoading = false.obs;

  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final int limit = 10;
  Future<void> fetchMyBooks({bool loadMore = false}) async {
    if (loadMore) {
      if (currentPage.value >= totalPages.value) return;
      currentPage.value++;
    } else {
      // Fresh fetch — reset to page 1 and clear list
      currentPage.value = 1;
      books.clear();
    }

    try {
      isBookLoading.value = true;
      errorMessage.value = '';

      final response = await BaseService().baseGetAPI(
        ApiEndPoints.listMyBooks(page: currentPage.value, limit: limit),
      );

      if (response['success'] == true) {
        // baseGetAPI Map response ko spread karta hai (...jsonData),
        // isliye 'response' hi seedha MyBooksResponse.fromJson mein ja sakta hai
        final data = MyBooksResponse.fromJson(response);

        if (loadMore) {
          books.addAll(data.items);
        } else {
          books.assignAll(data.items);
        }

        totalPages.value = data.totalPages;
      } else {
        // Agar loadMore fail hua to page number wapas kar do,
        // warna agli baar galat page se try hoga
        if (loadMore) currentPage.value--;

        errorMessage.value =
            response['message']?.toString() ?? 'Failed to load books';
        // baseGetAPI already toast dikha chuka hai error case mein — dobara mat dikhao
      }
    } catch (e) {
      if (loadMore) currentPage.value--;
      debugPrint('fetchMyBooks error: $e');
      errorMessage.value = 'Something went wrong while loading books';
      Utils.showToast(errorMessage.value, true);
    } finally {
      isBookLoading.value = false;
    }
  }
  Future<void> refreshBooks() async {
    await fetchMyBooks();
  }
}
