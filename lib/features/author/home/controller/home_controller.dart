import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';
import '../model/home_model.dart';
import 'package:http/http.dart' as http;
class AuthorHomeController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  var authorStats = Rxn<SubscriptionStats>();
  RxBool isStatsLoading = false.obs;

  var autographList = <AutographItemModel>[].obs;

  var isFetchPending = false.obs;
  RxString errorMessage = ''.obs;

  final RxList<Map<String, String>> requests = <Map<String, String>>[
    {
      'imagePath': 'assets/png/pendingimg.png',
      'authorName': 'Jane Austen',
      'date': '22 june, 2026',
      'bookName': 'The Origin of Species',
    },
    {
      'imagePath': 'assets/png/searchprofile.png',
      'authorName': 'Emily Bronte',
      'date': '24 june, 2026',
      'bookName': 'Wuthering Heights',
    },
    {
      'imagePath': 'assets/png/searchprofile.png',
      'authorName': 'George Orwell',
      'date': '26 june, 2026',
      'bookName': '1984',
    },
    {
      'imagePath': 'assets/png/searchprofile.png',
      'authorName': 'Mark Twain',
      'date': '28 june, 2026',
      'bookName': 'Adventures of Tom Sawyer',
    },
  ].obs;

  final RxList<Map<String, String>> filteredRequests =
      <Map<String, String>>[].obs;

  @override
  void onInit() {
    filteredRequests.assignAll(requests);
    super.onInit();
    fetchLibraryStats();
    fetchAutographRequests();
  }


  Future<void> refreshHomeRequests() async {
    // Apni wahi API call yahan dobara call karein jo data fetch karti hai
    fetchLibraryStats();
    fetchAutographRequests();
  }



  Future<void> refreshPendingRequest() async {
    // Apni wahi API call yahan dobara call karein jo data fetch karti hai

    fetchAutographRequests();
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

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchLibraryStats() async {
    try {
      isStatsLoading.value = true;

      final response = await BaseService().baseGetAPI(ApiEndPoints.authorStats);

      // Agar response direct data object hai:
      if (response != null) {
        authorStats.value = SubscriptionStats.fromJson(response);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isStatsLoading.value = false;
    }
  }


  Future<void> fetchAutographRequests() async {
    try {
      isFetchPending.value = true;
      errorMessage.value = '';

      final prefs = SharedPreferencesMethod.storage;
      final String token = prefs.getString(LocalDBKeys.TOKEN) ?? '';// ya getString use karein

      if (token.isEmpty) {
        errorMessage.value = 'Token not found';
        Utils.showToast('Please login again', true);
        return;
      }

      final uri = Uri.parse(
        '${BaseService().baseURL}${ApiEndPoints.pendingRequest}',
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = jsonDecode(response.body);

        // FIX: Paginated response parse karein (jisme items ki list hoti hai)
        final paginatedData = PaginatedAutographResponse.fromJson(responseBody);

        // FIX: Sahi list variable par assignAll use karein
        autographList.assignAll(paginatedData.items);

      } else {
        final responseBody = jsonDecode(response.body);
        errorMessage.value =
            responseBody['message']?.toString() ?? 'Failed to load data';
        Utils.showToast(errorMessage.value, true);
      }
    } catch (e) {
      debugPrint('Error: $e');
      errorMessage.value = 'Something went wrong while loading data';
      Utils.showToast(errorMessage.value, true);
    } finally {
      isFetchPending.value = false;
      EasyLoading.dismiss();
    }
  }
}
