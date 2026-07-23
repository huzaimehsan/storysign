import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:storysign/features/reader/Home/model/user_profile_model.dart';

import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';
import '../model/home_model.dart';
import '../model/recently_signed_book_model.dart';

class HomeController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  final RxBool isPageLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint("HomeController onInit called");
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    isPageLoading.value = true;
    await Future.wait([
      fetchHomeData(),
      fetchMyBooks(),
      loadUserProfile(),
    ]);
    isPageLoading.value = false;
  }

  Future<void> refreshHomeRequests() async {
    isPageLoading.value = true;
    await Future.wait([
      fetchHomeData(),
      fetchMyBooks(),
      loadUserProfile(),
    ]);
    isPageLoading.value = false;
  }

  RxString selectedTab = "All".obs;

  final TextEditingController bookTitleController = TextEditingController();
  final TextEditingController bookTitleControllerRequest =
      TextEditingController();
  final TextEditingController personalMessageController =
      TextEditingController();

  RxList<NewBookItem> trackRequest = <NewBookItem>[].obs;
  final Rxn<File> bookPdfFile = Rxn<File>();
  final Rxn<File> bookCoverImage = Rxn<File>();
  Rxn<UserProfile> userProfile = Rxn<UserProfile>();

  RxInt selectedAuthorIndex = 0.obs;

  // HomeController mein
  RxString selectedAuthorId = "".obs;
  RxString userName = 'User'.obs;
  RxString userRole = ''.obs;
  RxBool isUserDataLoading = false.obs;


  RxString searchQuery = "".obs;
  RxList<AllAuthorModel> welcomes = <AllAuthorModel>[].obs;
  Rxn<AuthorDetailModel> authorDetailData = Rxn<AuthorDetailModel>();

  RxBool isLoading = false.obs;

  RxBool trackRequestLoading = false.obs;
  RxBool isFetchHome = false.obs;
  RxString errorMessage = ''.obs;

  List<AllAuthorModel> get filteredAuthors {
    if (searchQuery.value.trim().isEmpty) {
      return welcomes;
    }
    final query = searchQuery.value.toLowerCase().trim();
    return welcomes
        .where((author) => author.fullName.toLowerCase().contains(query))
        .toList();
  }

  List<MyBookModel> get filteredBooks {
    if (searchQuery.value.trim().isEmpty) {
      return books;
    }
    final query = searchQuery.value.toLowerCase().trim();
    return books
        .where((book) => book.title.toLowerCase().contains(query))
        .toList();
  }

  // -----------------------------------------------------------------------------------------//
  RxString sortBy = "None"
      .obs; // "None", "Title A-Z", "Title Z-A", "Date Newest", "Date Oldest"
  RxString filterStatus =
      "All".obs; // "All", "In process", "Delivered", "Signed", "Unsigned"

  // ye helper method bhi add karein (class ke andar kahin bhi):
  DateTime _parseDate(String dateStr) {
    try {
      final parsed = DateTime.tryParse(dateStr);
      if (parsed != null) return parsed;
    } catch (_) {}
    return DateTime.now();
  }

  // filteredBooks getter POORI TARAH HATA DEIN (booksList declare hi nahi hai yahan)

  // filteredTrackRequest ko is se replace karein:
  List<NewBookItem> get filteredTrackRequest {
    List<NewBookItem> requests = List<NewBookItem>.from(trackRequest);

    // 1. Tab filter (All / In Process / Delivered)
    if (selectedTab.value == "In Process") {
      requests = requests.where((item) => item.status == "In process").toList();
    } else if (selectedTab.value == "Delivered") {
      requests = requests.where((item) => item.status == "Delivered").toList();
    }

    // 2. Search query
    if (searchQuery.value.trim().isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      requests = requests.where((item) {
        final title = item.title.toLowerCase();
        final author = item.author.fullName.toLowerCase();
        return title.contains(query) || author.contains(query);
      }).toList();
    }

    // 3. Status filter (dropdown se)
    if (filterStatus.value != "All") {
      requests = requests
          .where((item) => item.status == filterStatus.value)
          .toList();
    }

    // 4. Sort
    if (sortBy.value == "Title A-Z") {
      requests.sort((a, b) => a.title.compareTo(b.title));
    } else if (sortBy.value == "Title Z-A") {
      requests.sort((a, b) => b.title.compareTo(a.title));
    } else if (sortBy.value == "Date Newest") {
      requests.sort(
        (a, b) => _parseDate(b.uploadDate).compareTo(_parseDate(a.uploadDate)),
      );
    } else if (sortBy.value == "Date Oldest") {
      requests.sort(
        (a, b) => _parseDate(a.uploadDate).compareTo(_parseDate(b.uploadDate)),
      );
    }

    return requests;
  }

  // resetFilter ko bhi update kar dein taake sort/filter bhi reset ho:
  void resetFilter() {
    selectTab("All");
    sortBy.value = "None";
    filterStatus.value = "All";
  }

  void selectAuthor(int index) {
    selectedAuthorIndex.value = index;
  }

  void selectTab(String tab) {
    selectedTab.value = tab;
  }

  void applyFilter(String tab) {
    selectTab(tab);
  }

  List<AllAuthorModel> get allAuthor {
    // 1. Agar search bar khali hai, toh poori list (welcomes) wapas kar do.
    if (searchQuery.value.trim().isEmpty) {
      return welcomes;
    }

    final query = searchQuery.value.toLowerCase().trim();

    return welcomes
        .where((author) => author.fullName.toLowerCase().contains(query))
        .toList();
  }

  Future<void> fetchHomeData() async {
    try {
      isFetchHome.value = true;
      errorMessage.value = '';

      final response = await BaseService().baseGetAPI(ApiEndPoints.allAuthor);

      if (response['success'] == true) {
        // baseGetAPI list response ko 'data' key ke andar deta hai,
        // aur Map response ko spread karke deta hai — dono handle karo
        final dynamic rawData = response['data'] ?? response['items'] ?? response;

        final List<dynamic> items = rawData is List
            ? rawData
            : (rawData is Map && rawData['data'] is List
            ? rawData['data'] as List
            : const []);

        welcomes.assignAll(
          items
              .map((e) => AllAuthorModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to load home data';
        // Utils.showToast already baseGetAPI ke andar call ho chuka hai error case mein,
        // isliye yahan dobara call karne ki zarurat nahi
      }
    } catch (e) {
      debugPrint('fetchHomeData error: $e');
      errorMessage.value = 'Something went wrong while loading data';
      Utils.showToast(errorMessage.value, true);
    } finally {
      isFetchHome.value = false;
    }
  }

  //---------------------------------------------------------------------------//
  // upload book function — moved to UploadBookController
  // authorDetail — moved to AuthorDetailController
  // downloadBook — moved to SignedCopyController

  final RxList<MyBookModel> books = <MyBookModel>[].obs;
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

  Future<void> loadUserProfile() async {
    try {
      isUserDataLoading.value = true;
      final prefs = SharedPreferencesMethod.storage;
      userRole.value = prefs.getString('role') ?? '';

      final token = prefs.getString(LocalDBKeys.TOKEN) ?? '';
      if (token.isEmpty) {
        return;
      }

      final response = await BaseService().baseGetAPI(ApiEndPoints.profile);

      if (response['success'] == true) {
        // baseGetAPI Map response ko spread karke deta hai (...jsonData),
        // isliye agar backend {"data": {...}} bhejta hai to us key ko check karo
        final profileData = response['data'] is Map
            ? Map<String, dynamic>.from(response['data'] as Map)
            : Map<String, dynamic>.from(response);

        userProfile.value = UserProfile.fromJson(profileData);

        final fullName =
            userProfile.value?.fullName ??
                profileData['fullName']?.toString() ??
                profileData['name']?.toString() ??
                '';
        if (fullName.isNotEmpty) {
          userName.value = fullName;
        }
      }
    } catch (e) {
      debugPrint('HomeController loadUserProfile error: $e');
    } finally {
      isUserDataLoading.value = false;
    }
  }
}
