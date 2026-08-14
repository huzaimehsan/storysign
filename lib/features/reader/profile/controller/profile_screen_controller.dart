
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:storysign/features/reader/profile/model/recently_signed_book_model.dart';
import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';

import '../../bottomNav/controller/bottom_nav_controller.dart';
import '../../../../utils/utility.dart';
import '../model/profile_screen_model.dart';

class ProfileScreenController extends GetxController {
  void popTab() {
    if (Get.isRegistered<BottomNavController>()) {
      Get.find<BottomNavController>().popCurrentTabOrGoToPrevious();
    }
  }

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();
  Rxn<LibraryStatsModel> libraryStats = Rxn<LibraryStatsModel>();
  RxBool isStatsLoading = false.obs;
  RxList<BookItem> bookList = <BookItem>[].obs;
  RxBool isbookLoading = false.obs;
  RxBool isLoadingMoreHistory = false.obs;
  RxInt historyCurrentPage = 1.obs;
  RxInt historyTotalPages = 1.obs;
  final int historyLimit = 10;

  @override
  void onInit() {
    super.onInit();
    errorMessage.value = '';
    booksScrollController.addListener(_onBooksScroll);
    getProfile();
    fetchLibraryStats();
    downloadHistory();
    fetchMyBooks();
  }

  void _onBooksScroll() {
    if (booksScrollController.position.pixels >=
            booksScrollController.position.maxScrollExtent - 120) {
      if (!isBookLoading.value &&
          !isLoadingMoreBooks.value &&
          currentPage.value < totalPages.value) {
        fetchMyBooks(loadMore: true);
        return;
      }

      if (!isbookLoading.value &&
          !isLoadingMoreHistory.value &&
          historyCurrentPage.value < historyTotalPages.value) {
        downloadHistory(loadMore: true);
      }
    }
  }

  Future<void> refreshRequests() async {
    errorMessage.value = '';
    await Future.wait([
      getProfile(),
      fetchLibraryStats(),
      downloadHistory(),
      fetchMyBooks(),
    ]);
  }

  Future<void> getProfile() async {
    try {
      isLoading.value = true;

      final response = await BaseService().baseGetAPI(
        ApiEndPoints.profile,
        loading: false,
        showErrorToast: false,
      );

      if (response['success'] == true) {

        profileModel.value = ProfileModel.fromJson(response);
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to load profile';
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
      final response = await BaseService().baseGetAPI(
        ApiEndPoints.libraryStats,
        loading: false,
        showErrorToast: false,
      );
      if (response != null) {
        libraryStats.value = LibraryStatsModel.fromJson(response);
      }
    } catch (e) {
      debugPrint('ProfileScreenController fetchLibraryStats error: $e');
    } finally {
      isStatsLoading.value = false;
    }
  }

  Future<void> downloadHistory({bool loadMore = false}) async {
    if (loadMore) {
      if (historyCurrentPage.value >= historyTotalPages.value) return;
      historyCurrentPage.value++;
    } else {
      historyCurrentPage.value = 1;
      bookList.clear();
    }

    try {
      if (loadMore) {
        isLoadingMoreHistory.value = true;
      } else {
        isbookLoading.value = true;
      }

      final response = await BaseService().baseGetAPI(
        ApiEndPoints.bookHistory(
          page: historyCurrentPage.value,
          limit: historyLimit,
        ),
        loading: false,
        showErrorToast: false,
      );

      if (response['success'] == true) {
        final data = BookResponse.fromJson(response);
        if (loadMore) {
          bookList.addAll(data.items);
        } else {
          bookList.assignAll(data.items);
        }
        historyTotalPages.value = data.totalPages;
      }
    } catch (e) {
      if (loadMore) historyCurrentPage.value--;
      debugPrint('ProfileScreenController downloadHistory error: $e');
    } finally {
      if (loadMore) {
        isLoadingMoreHistory.value = false;
      } else {
        isbookLoading.value = false;
      }
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
  final RxList<MyProfileBookModel> books = <MyProfileBookModel>[].obs;
  final RxBool isBookLoading = false.obs;
  final RxBool isLoadingMoreBooks = false.obs;
  final ScrollController booksScrollController = ScrollController();

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
      if (loadMore) {
        isLoadingMoreBooks.value = true;
      } else {
        isBookLoading.value = true;
      }

      final response = await BaseService().baseGetAPI(
        ApiEndPoints.listMyBooks(page: currentPage.value, limit: limit),
        loading: false,
        showErrorToast: false,
      );

      if (response['success'] == true) {
        final data = MyBooksResponse.fromJson(response);
        if (loadMore) {
          books.addAll(data.items);
        } else {
          books.assignAll(data.items);
        }
        totalPages.value = data.totalPages;
      } else {
        if (loadMore) currentPage.value--;
        // Secondary call — only toast, do NOT set errorMessage (profile is already loaded)
        debugPrint('fetchMyBooks API error: ${response['message']}');
      }
    } catch (e) {
      if (loadMore) currentPage.value--;
      debugPrint('fetchMyBooks error: $e');
      // Secondary call — only toast, do NOT set errorMessage (profile is already loaded)
    } finally {
      if (loadMore) {
        isLoadingMoreBooks.value = false;
      } else {
        isBookLoading.value = false;
      }
    }
  }

  Future<void> refreshBooks() async {
    await fetchMyBooks();
  }

  @override
  void onClose() {
    booksScrollController.removeListener(_onBooksScroll);
    booksScrollController.dispose();
    super.onClose();
  }
}
