import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storysign/core/services/apiendpoints.dart';
import 'package:storysign/core/services/base_services.dart';
import 'package:storysign/utils/utility.dart';

import '../model/delivered_model.dart';
// adjust to your actual path

class DeliveredController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxBool isFetchPending = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;

  final RxList<DeliveryItemModel> requests = <DeliveryItemModel>[].obs;
  final RxList<DeliveryItemModel> filteredRequests = <DeliveryItemModel>[].obs;
  final ScrollController scrollController = ScrollController();

  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final int limit = 10;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    fetchDeliveryRequests();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 120 &&
        !isFetchPending.value &&
        !isLoadingMore.value &&
        currentPage.value < totalPages.value) {
      fetchDeliveryRequests(loadMore: true);
    }
  }

  Future<void> refreshDeliveryRequests() async {
    await fetchDeliveryRequests();
  }

  void filterRequests(String query) {
    final lowerQuery = query.toLowerCase().trim();

    if (lowerQuery.isEmpty) {
      filteredRequests.assignAll(requests);
      return;
    }

    filteredRequests.assignAll(
      requests.where((request) {
        final authorName = request.author?.fullName.toLowerCase() ?? '';
        final bookName = request.bookTitle.toLowerCase();
        return authorName.contains(lowerQuery) || bookName.contains(lowerQuery);
      }).toList(),
    );
  }

  Future<void> fetchDeliveryRequests({bool loadMore = false}) async {
    if (loadMore) {
      if (currentPage.value >= totalPages.value) return;
      currentPage.value++;
    } else {
      currentPage.value = 1;
      requests.clear();
      filteredRequests.clear();
    }

    try {
      if (loadMore) {
        isLoadingMore.value = true;
      } else {
        isFetchPending.value = true;
      }
      errorMessage.value = '';

      final response = await BaseService().baseGetAPI(
        ApiEndPoints.deliveryRequest(page: currentPage.value, limit: limit),
        loading: false,
      );

      debugPrint('Delivery API response: $response');

      if (response['success'] == true) {
        final dynamic payload = response['data'] ?? response;

        Map<String, dynamic> payloadMap;
        if (payload is List) {
          payloadMap = {
            'items': payload,
            'total': payload.length,
            'page': 1,
            'limit': payload.length,
            'totalPages': 1,
          };
        } else if (payload is Map<String, dynamic>) {
          payloadMap = Map<String, dynamic>.from(payload);
        } else {
          payloadMap = {};
        }

        final paginatedData = DeliveryResponse.fromJson(payloadMap);
        if (loadMore) {
          requests.addAll(paginatedData.items);
        } else {
          requests.assignAll(paginatedData.items);
        }
        filteredRequests.assignAll(requests);
        totalPages.value = paginatedData.totalPages;

        debugPrint('Parsed delivery items count: ${paginatedData.items.length}');
      } else {
        if (loadMore && currentPage.value > 1) currentPage.value--;
        errorMessage.value = response['message']?.toString() ?? 'Failed to load data';
        debugPrint('Delivery API error: ${errorMessage.value}');
      }
    } catch (e) {
      if (loadMore && currentPage.value > 1) currentPage.value--;
      debugPrint('Error: $e');
      errorMessage.value = 'Something went wrong while loading data';
    } finally {
      if (loadMore) {
        isLoadingMore.value = false;
      } else {
        isFetchPending.value = false;
      }
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}