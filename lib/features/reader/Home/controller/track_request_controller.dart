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

  @override
  void onInit() {
    super.onInit();
    ever(selectedTab, (_) => fetchTrackRequestData());
    fetchTrackRequestData();
  }

  //
  // Future<void> fetchTrackRequestData() async {
  //   try {
  //     trackRequestLoading.value = true;
  //     errorMessage.value = '';
  //
  //     final token = SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
  //     if (token.isEmpty) {
  //       errorMessage.value = 'Token not found';
  //       Utils.showToast('Please login again', true);
  //       return;
  //     }
  //
  //     final uri = Uri.parse('${BaseService().baseURL}${ApiEndPoints.trackRequest}');
  //     final response = await http.get(uri, headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     });
  //
  //     if (response.statusCode >= 200 && response.statusCode < 300) {
  //       final responseBody = jsonDecode(response.body);
  //       final Map<String, dynamic> data = responseBody is Map && responseBody['data'] is Map
  //           ? responseBody['data']
  //           : responseBody;
  //
  //       final trackRequestData = TrackRequestModel.fromJson(data);
  //       trackRequest.assignAll(trackRequestData.items);
  //       currentPage.value = trackRequestData.page;
  //       totalPages.value = trackRequestData.totalPages;
  //       totalItems.value = trackRequestData.total;
  //     } else {
  //       Utils.showToast('Failed to load data', true);
  //     }
  //   } catch (e) {
  //     errorMessage.value = 'Something went wrong: $e';
  //     Utils.showToast(errorMessage.value, true);
  //   } finally {
  //     trackRequestLoading.value = false;
  //   }
  // }
  Future<void> fetchTrackRequestData() async {
    try {
      trackRequestLoading.value = true;
      errorMessage.value = '';

      final statusFilter = selectedTab.value == 'All'
          ? null
          : selectedTab.value == 'In Process'
              ? 'in_progress'
              : 'delivered';

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
        trackRequest.assignAll(trackRequestData.items);
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
      trackRequestLoading.value = false;
    }
  }

  void resetFilter() {
    selectedTab.value = "All";
    sortBy.value = "None";
    filterStatus.value = "All";
  }

  Future<void> refreshRequests() async {
    await fetchTrackRequestData();
  }

  List<NewBookItem> get filteredTrackRequest {
    final tab = selectedTab.value.toLowerCase();
    final query = searchQuery.value.toLowerCase().trim();

    final filteredByTab = trackRequest.where((book) {
      final status = book.status.toLowerCase();
      if (tab == 'in process') {
        return status == 'in_process' || status == 'in process';
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
