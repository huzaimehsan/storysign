import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/utility.dart';
import '../model/profile_screen_model.dart';

class ProfileDownloadHistoryController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  Timer? _searchDebounce;

  final RxList<BookItem> bookList = <BookItem>[].obs;
  final RxBool isbookLoading = false.obs;
  final RxBool isLoadingMoreHistory = false.obs;
  final ScrollController scrollController = ScrollController();

  final RxInt historyCurrentPage = 1.obs;
  final RxInt historyTotalPages = 1.obs;
  final int historyLimit = 10;

  RxString searchQuery = ''.obs;
  RxString sortBy = "Newest".obs; // "Newest", "Oldest", "Title A-Z", "Title Z-A"
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    ever(searchQuery, (_) => _applyFiltersAndSort());
    ever(sortBy, (_) => _applyFiltersAndSort());
    _loadAllData();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 500 &&
        !isbookLoading.value &&
        !isLoadingMoreHistory.value &&
        historyCurrentPage.value < historyTotalPages.value) {
      downloadHistory(loadMore: true);
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      _applyFiltersAndSort();
    });
  }

  List<BookItem> get filteredBooks {
    var result = bookList.toList();

    // Apply search filter
    if (searchQuery.value.trim().isNotEmpty) {
      final query = searchQuery.value.toLowerCase().trim();
      result = result
          .where((book) => book.bookTitle.toLowerCase().contains(query))
          .toList();
    }

    // Apply sorting
    if (sortBy.value == "Newest") {
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (sortBy.value == "Oldest") {
      result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } else if (sortBy.value == "Title A-Z") {
      result.sort((a, b) => a.bookTitle.compareTo(b.bookTitle));
    } else if (sortBy.value == "Title Z-A") {
      result.sort((a, b) => b.bookTitle.compareTo(a.bookTitle));
    }

    return result;
  }

  void _applyFiltersAndSort() {
    bookList.refresh();
  }

  Future<void> _loadAllData() async {
    isbookLoading.value = true;
    await downloadHistory();
    isbookLoading.value = false;
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
      debugPrint('downloadHistory error: $e');
      errorMessage.value = 'Something went wrong while loading history';
      Utils.showToast(errorMessage.value, true);
    } finally {
      if (loadMore) {
        isLoadingMoreHistory.value = false;
      } else {
        isbookLoading.value = false;
      }
    }
  }

  Future<void> refreshHistory() async {
    await downloadHistory();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}
