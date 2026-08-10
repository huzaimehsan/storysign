import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storysign/core/services/apiendpoints.dart';
import 'package:storysign/core/services/base_services.dart';
import 'package:storysign/utils/utility.dart';

class AllRequestController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxBool isFetchPending = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;

  final RxList<Map<String, String>> requests = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> filteredRequests = <Map<String, String>>[].obs;
  final ScrollController scrollController = ScrollController();

  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final int limit = 10;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    fetchPendingRequests();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 120 &&
        !isFetchPending.value &&
        !isLoadingMore.value &&
        currentPage.value < totalPages.value) {
      fetchPendingRequests(loadMore: true);
    }
  }

  void filterRequests(String query) {
    final lowerQuery = query.toLowerCase().trim();

    if (lowerQuery.isEmpty) {
      filteredRequests.assignAll(requests);
      return;
    }

    filteredRequests.assignAll(
      requests.where((request) {
        final authorName = request['authorName']?.toLowerCase() ?? '';
        final bookName = request['bookName']?.toLowerCase() ?? '';
        return authorName.contains(lowerQuery) || bookName.contains(lowerQuery);
      }).toList(),
    );
  }

  Future<void> fetchPendingRequests({bool loadMore = false}) async {
    if (loadMore) {
      if (currentPage.value >= totalPages.value) return;
      currentPage.value++;
    } else {
      currentPage.value = 1;
      requests.clear();
      filteredRequests.clear();
    }

    if (!loadMore) {
      isFetchPending.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await BaseService().baseGetAPI(
        ApiEndPoints.pendingRequest(page: currentPage.value, limit: limit),
        loading: false,
        showErrorToast: false,
      );

      if (response['success'] == true) {
        final items = response['items'] as List? ?? [];
        final loaded = items.map((item) {
          final data = item as Map<String, dynamic>;
          return {
            'id': data['id']?.toString() ?? '',
            'imagePath': data['reader']?['profilePicture']?.toString() ?? '',
            'authorName': data['author']?['fullName']?.toString() ?? '',
            'bookName': data['bookTitle']?.toString() ?? '',
            'date': data['requestDate']?.toString() ?? '',
          };
        }).toList().cast<Map<String, String>>();

        if (loadMore) {
          requests.addAll(loaded);
        } else {
          requests.assignAll(loaded);
        }
        filteredRequests.assignAll(requests);
        currentPage.value = response['page'] ?? currentPage.value;
        totalPages.value = response['totalPages'] ?? totalPages.value;
      }
    } catch (e) {
      if (loadMore && currentPage.value > 1) currentPage.value--;
      Utils.showToast('Failed to load pending requests', true);
    } finally {
      if (loadMore) {
        isLoadingMore.value = false;
      } else {
        isFetchPending.value = false;
      }
    }
  }

  Future<void> refreshPendingRequest() async {
    await fetchPendingRequests();
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}
