import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:storysign/features/author/home/model/author_profile_model.dart';

import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';
import '../model/active_subscription_model.dart';
import '../model/home_model.dart';
import 'package:http/http.dart' as http;
class AuthorHomeController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  var authorStats = Rxn<SubscriptionStats>();

  var activeSub = Rxn<activeSubscription>();
  RxBool isStatsLoading = false.obs;
  Rxn<AuthorUserProfile> userAuthorProfile = Rxn<AuthorUserProfile>();
  var autographList = <AutographItemModel>[].obs;
  var filteredAutographList = <AutographItemModel>[].obs;
  RxString userRole = ''.obs;
  var isFetchPending = false.obs;

  var isUserDataLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLibraryStats();
    fetchAutographRequests();
    loadAuthorProfile();
    fetchSubscriptionPlan();
    // Search query change hone par list filter karo
    ever(searchQuery, (_) => _applyFilter());
  }

  void _applyFilter() {
    final q = searchQuery.value.toLowerCase().trim();
    if (q.isEmpty) {
      filteredAutographList.assignAll(autographList);
    } else {
      filteredAutographList.assignAll(
        autographList.where((item) {
          final book = item.bookTitle.toLowerCase();
          final reader = item.reader.fullName.toLowerCase();
          return book.contains(q) || reader.contains(q);
        }).toList(),
      );
    }
  }


  Future<void> refreshHomeRequests() async {
    fetchLibraryStats();
    fetchAutographRequests();
    fetchSubscriptionPlan();
    loadAuthorProfile();
  }



  Future<void> refreshPendingRequest() async {
    // Apni wahi API call yahan dobara call karein jo data fetch karti hai

    fetchAutographRequests();
  }



  void filterRequests(String query) {
    searchQuery.value = query;
  }

  // @override
  // void onClose() {
  //   searchController.dispose();
  //   super.onClose();
  // }

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
        // Fetch ke baad filtered list bhi update karo
        _applyFilter();

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

  Future<void> fetchSubscriptionPlan() async {
    try {
      final response = await BaseService().baseGetAPI(ApiEndPoints.currentSubscription);
      if (response != null) {
        activeSub.value = activeSubscription.fromJson(response);
      }
    } catch (e) {
      debugPrint("fetchSubscriptionPlan error: $e");
    }
  }


  Future<void> loadAuthorProfile() async {
    try {
      isUserDataLoading.value = true;
      final prefs = SharedPreferencesMethod.storage;
      userRole.value = prefs.getString('role') ?? '';

      final token = prefs.getString(LocalDBKeys.TOKEN) ?? '';
      if (token.isEmpty) {
        return;
      }

      final uri = Uri.parse('${BaseService().baseURL}${ApiEndPoints.authorProfile}');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = jsonDecode(response.body);
        if (responseBody is Map) {
          final profileData = responseBody['data'] is Map
              ? responseBody['data'] as Map<String, dynamic>
              : Map<String, dynamic>.from(responseBody);

          userAuthorProfile.value = AuthorUserProfile.fromJson(profileData);

          final fullName =
              userAuthorProfile.value?.fullName ??
                  profileData['fullName']?.toString() ??
                  profileData['name']?.toString() ??
                  '';
          if (fullName.isNotEmpty) {
            userAuthorProfile.value = fullName as AuthorUserProfile?;
          }
        }
      }
    } catch (e) {
      debugPrint('HomeController loadUserProfile error: $e');
    } finally {
      isUserDataLoading.value = false;
    }
  }

}
