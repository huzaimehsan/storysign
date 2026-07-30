import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storysign/features/author/home/model/author_profile_model.dart';

import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../model/active_subscription_model.dart';
import '../model/home_model.dart';
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

      final response = await BaseService().baseGetAPI(
        ApiEndPoints.authorStats,
        loading: false,
        showErrorToast: false,
      );

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

      final response = await BaseService().baseGetAPI(
        ApiEndPoints.pendingRequest(),
        loading: false,
        showErrorToast: false,
      );

      if (response['success'] == true) {
        final paginatedData = PaginatedAutographResponse.fromJson(response);
        autographList.assignAll(paginatedData.items);
        _applyFilter();
      } else {
        errorMessage.value = response['message']?.toString() ?? 'Failed to load data';
      }
    } catch (e) {
      debugPrint('Error: $e');
      errorMessage.value = 'Something went wrong while loading data';
    } finally {
      isFetchPending.value = false;
    }
  }

  Future<void> fetchSubscriptionPlan() async {
    try {
      final response = await BaseService().baseGetAPI(
        ApiEndPoints.currentSubscription,
        loading: false,
        showErrorToast: false,
      );
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
      userRole.value = SharedPreferencesMethod.storage.getString('role') ?? '';

      final response = await BaseService().baseGetAPI(
        ApiEndPoints.authorProfile,
        loading: false,
        showErrorToast: false,
      );

      if (response['success'] == true) {
        final profileData = response['data'] is Map
            ? response['data'] as Map<String, dynamic>
            : Map<String, dynamic>.from(response);
        userAuthorProfile.value = AuthorUserProfile.fromJson(profileData);
      }
    } catch (e) {
      debugPrint('loadAuthorProfile error: $e');
    } finally {
      isUserDataLoading.value = false;
    }
  }

}
