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

      final response = await BaseService().baseGetAPI(
        loading: false,
        ApiEndPoints.trackRequest,
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
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to load data';
      }
    } catch (e) {
      debugPrint('fetchTrackRequestData error: $e');
      errorMessage.value = 'Something went wrong: $e';
      Utils.showToast(errorMessage.value, true);
    } finally {
      trackRequestLoading.value = false;
    }
  }

  DateTime _parseDate(String dateStr) {
    try {
      final parsed = DateTime.tryParse(dateStr);
      if (parsed != null) return parsed;
    } catch (_) {}
    return DateTime.now();
  }

  List<NewBookItem> get filteredTrackRequest {
    List<NewBookItem> requests = List<NewBookItem>.from(trackRequest);

    if (selectedTab.value == "In Process") {
      requests = requests.where((item) {
        final st = item.status.toLowerCase().replaceAll(' ', '_');
        return st == "in_process" || st == "in_progress" || st == "pending";
      }).toList();
    } else if (selectedTab.value == "Delivered" ||
        selectedTab.value == "Signed") {
      requests = requests.where((item) {
        final st = item.status.toLowerCase().replaceAll(' ', '_');
        return st == "delivered" ||
            st == "rejected" ||
            st == "completed" ||
            st == "approved";
      }).toList();
    }

    if (searchQuery.value.trim().isNotEmpty) {
      final query = searchQuery.value.toLowerCase().trim();
      requests = requests
          .where(
            (item) =>
                item.title.toLowerCase().contains(query) ||
                item.author.fullName.toLowerCase().contains(query),
          )
          .toList();
    }

    if (filterStatus.value != "All") {
      final targetStatus = filterStatus.value.toLowerCase().replaceAll(
        ' ',
        '_',
      );
      requests = requests.where((item) {
        final st = item.status.toLowerCase().replaceAll(' ', '_');
        if (targetStatus == "in_process") {
          return st == "in_process" || st == "in_progress" || st == "pending";
        }
        if (targetStatus == "delivered" || targetStatus == "signed") {
          return st == "delivered" ||
              st == "rejected" ||
              st == "completed" ||
              st == "approved";
        }
        return st == targetStatus;
      }).toList();
    }

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

  void resetFilter() {
    selectedTab.value = "All";
    sortBy.value = "None";
    filterStatus.value = "All";
  }

  Future<void> refreshRequests() async {
    await fetchTrackRequestData();
  }
}
