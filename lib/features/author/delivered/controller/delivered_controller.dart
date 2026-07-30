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
  final RxString errorMessage = ''.obs;

  final RxList<DeliveryItemModel> requests = <DeliveryItemModel>[].obs;
  final RxList<DeliveryItemModel> filteredRequests = <DeliveryItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDeliveryRequests();
  }
  Future<void> refreshDeliveryRequests() async {
    isFetchPending.value = true;
    await Future.wait([fetchDeliveryRequests()]);
    isFetchPending.value = false;
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

  Future<void> fetchDeliveryRequests() async {
    try {
      isFetchPending.value = true;
      errorMessage.value = '';

      final response = await BaseService().baseGetAPI(
        ApiEndPoints.deliveryRequest(),
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
        requests.assignAll(paginatedData.items);
        filteredRequests.assignAll(paginatedData.items);

        debugPrint('Parsed delivery items count: ${paginatedData.items.length}');
      } else {
        errorMessage.value = response['message']?.toString() ?? 'Failed to load data';
        debugPrint('Delivery API error: ${errorMessage.value}');
      }
    } catch (e) {
      debugPrint('Error: $e');
      errorMessage.value = 'Something went wrong while loading data';
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