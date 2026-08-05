import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';

import '../../../../utils/utility.dart';
import '../model/home_model.dart';

class TrackRequestController extends GetxController {
  RxList<NewBookItem> trackRequest = <NewBookItem>[].obs;
  RxBool trackRequestLoading = false.obs;
  RxString errorMessage = ''.obs;
  final TextEditingController searchController = TextEditingController();
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxInt totalItems = 0.obs;

  // Filter/Sort Variables
  RxString selectedTab = "All".obs;
  RxString sortBy = "None".obs;
  RxString filterStatus = "All".obs;
  RxString searchQuery = "".obs;
  RxBool isLoadingMore = false.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    ever(selectedTab, (_) {
      currentPage.value = 1;
      fetchTrackRequestData();
    });
    ever(filterStatus, (_) {
      currentPage.value = 1;
      fetchTrackRequestData();
    });
    fetchTrackRequestData();
  }

  Future<void> fetchTrackRequestData({bool loadMore = false}) async {
    try {
      if (loadMore) {
        isLoadingMore.value = true;
      } else {
        trackRequestLoading.value = true;
        errorMessage.value = '';
      }

      final activeStatus = filterStatus.value != 'All'
          ? filterStatus.value
          : selectedTab.value;

      final statusFilter = activeStatus.toLowerCase() == 'all'
          ? null
          : activeStatus.toLowerCase() == 'submitted'
              ? 'submitted'
              : activeStatus.toLowerCase() == 'in process'
                  ? 'in_progress'
                  : activeStatus.toLowerCase() == 'delivered'
                      ? 'delivered'
                      : activeStatus.toLowerCase() == 'rejected'
                          ? 'rejected'
                          : null;

      final endpoint = statusFilter != null
          ? '${ApiEndPoints.trackRequest}?page=${currentPage.value}&limit=10&status=${Uri.encodeQueryComponent(statusFilter)}'
          : '${ApiEndPoints.trackRequest}?page=${currentPage.value}&limit=10';

      final response = await BaseService().baseGetAPI(
        endpoint,
        loading: false,
        showErrorToast: false,
      );

      if (response['success'] == true) {
        final Map<String, dynamic> data = response['data'] is Map
            ? Map<String, dynamic>.from(response['data'] as Map)
            : response;

        final trackRequestData = TrackRequestModel.fromJson(data);
        if (loadMore) {
          trackRequest.addAll(trackRequestData.items);
        } else {
          trackRequest.assignAll(trackRequestData.items);
        }
        currentPage.value = trackRequestData.page;
        totalPages.value = trackRequestData.totalPages;
        totalItems.value = trackRequestData.total;
      } else {
        errorMessage.value = response['message']?.toString() ?? 'Failed to load tracking data';
        Utils.showToast(errorMessage.value, true);
      }
    } catch (e) {
      debugPrint('fetchTrackRequestData error: $e');
      errorMessage.value = 'Something went wrong: $e';
      Utils.showToast(errorMessage.value, true);
    } finally {
      if (loadMore) {
        isLoadingMore.value = false;
      } else {
        trackRequestLoading.value = false;
      }
    }
  }

  void resetFilter() {
    selectedTab.value = "All";
    sortBy.value = "None";
    filterStatus.value = "All";
  }

  Future<void> refreshRequests() async {
    currentPage.value = 1;
    await fetchTrackRequestData();
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 120 &&
        !isLoadingMore.value &&
        !trackRequestLoading.value &&
        currentPage.value < totalPages.value) {
      currentPage.value++;
      fetchTrackRequestData(loadMore: true);
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  List<NewBookItem> get filteredTrackRequest {
    final tab = selectedTab.value.toLowerCase();
    final query = searchQuery.value.toLowerCase().trim();

    final filteredByTab = trackRequest.where((book) {
      final status = book.status.toLowerCase();
      if (tab == 'submitted') {
        return status == 'submitted';
      }
      if (tab == 'in process') {
        return status == 'in_progress' || status == 'in process';
      }
      if (tab == 'delivered') {
        return status == 'delivered';
      }
      return true;
    }).toList();

    if (query.isEmpty) {
      return filteredByTab;
    }

    return filteredByTab.where((book) {
      final title = book.title.toLowerCase();
      final author = book.author.fullName.toLowerCase();
      return title.contains(query) || author.contains(query);
    }).toList();
  }
}
