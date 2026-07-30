import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storysign/core/services/apiendpoints.dart';
import 'package:storysign/core/services/base_services.dart';
import 'package:storysign/utils/utility.dart';

class AllRequestController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxBool isFetchPending = false.obs;

  final RxList<Map<String, String>> requests = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> filteredRequests = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingRequests();
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

  Future<void> fetchPendingRequests() async {
    isFetchPending.value = true;
    try {
      final response = await BaseService().baseGetAPI(ApiEndPoints.pendingRequest());

      if (response['success'] == true) {
        final items = response['items'] as List? ?? [];
        requests.assignAll(
          items.map((item) {
            final data = item as Map<String, dynamic>;
            return {
              'id': data['id']?.toString() ?? '',
              'imagePath': data['reader']?['profilePicture']?.toString() ?? '',
              'authorName': data['author']?['fullName']?.toString() ?? '',
              'bookName': data['bookTitle']?.toString() ?? '',
              'date': data['requestDate']?.toString() ?? '',
            };
          }).toList().cast<Map<String, String>>(),
        );
        filteredRequests.assignAll(requests);
      }
    } catch (e) {
      Utils.showToast('Failed to load pending requests', true);
    } finally {
      isFetchPending.value = false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
