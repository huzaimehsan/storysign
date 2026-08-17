import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/utility.dart';
import '../model/recently_signed_book_model.dart';

class ProfileViewAllBooksController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  Timer? _searchDebounce;

  final RxList<MyProfileBookModel> books = <MyProfileBookModel>[].obs;
  final RxBool isBookLoading = false.obs;
  final RxBool isLoadingMoreBooks = false.obs;
  final ScrollController scrollController = ScrollController();

  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final int limit = 10;

  RxString searchQuery = ''.obs;
  RxString sortBy = "Newest".obs; // "Newest", "Oldest", "Title A-Z", "Title Z-A"
  RxString filterStatus = "All".obs; // "All", "Signed", "Unsigned"
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    ever(searchQuery, (_) => _applyFiltersAndSort());
    ever(sortBy, (_) => _applyFiltersAndSort());
    ever(filterStatus, (_) => _applyFiltersAndSort());
    _loadAllData();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 500 &&
        !isBookLoading.value &&
        !isLoadingMoreBooks.value &&
        currentPage.value < totalPages.value) {
      fetchMyBooks(loadMore: true);
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      _applyFiltersAndSort();
    });
  }

  List<MyProfileBookModel> get filteredBooks {
    var result = books.toList();

    // Apply search filter
    if (searchQuery.value.trim().isNotEmpty) {
      final query = searchQuery.value.toLowerCase().trim();
      result = result
          .where((book) =>
              book.title.toLowerCase().contains(query) ||
              book.authorName.toLowerCase().contains(query))
          .toList();
    }

    // Apply status filter
    if (filterStatus.value != "All") {
      result = result
          .where((book) => book.status.toLowerCase() == filterStatus.value.toLowerCase())
          .toList();
    }

    // Apply sorting
    if (sortBy.value == "Newest") {
      result.sort((a, b) => DateTime.parse(b.uploadDate).compareTo(DateTime.parse(a.uploadDate)));
    } else if (sortBy.value == "Oldest") {
      result.sort((a, b) => DateTime.parse(a.uploadDate).compareTo(DateTime.parse(b.uploadDate)));
    } else if (sortBy.value == "Title A-Z") {
      result.sort((a, b) => a.title.compareTo(b.title));
    } else if (sortBy.value == "Title Z-A") {
      result.sort((a, b) => b.title.compareTo(a.title));
    }

    return result;
  }

  void _applyFiltersAndSort() {
    books.refresh();
  }

  Future<void> _loadAllData() async {
    isBookLoading.value = true;
    await fetchMyBooks();
    isBookLoading.value = false;
  }

  Future<void> fetchMyBooks({bool loadMore = false}) async {
    if (loadMore) {
      if (currentPage.value >= totalPages.value) return;
      currentPage.value++;
    } else {
      currentPage.value = 1;
      books.clear();
    }

    try {
      if (loadMore) {
        isLoadingMoreBooks.value = true;
      } else {
        isBookLoading.value = true;
      }
      errorMessage.value = '';

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
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to load books';
      }
    } catch (e) {
      if (loadMore) currentPage.value--;
      debugPrint('fetchMyBooks error: $e');
      errorMessage.value = 'Something went wrong while loading books';
      Utils.showToast(errorMessage.value, true);
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
    _searchDebounce?.cancel();
    searchController.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}
