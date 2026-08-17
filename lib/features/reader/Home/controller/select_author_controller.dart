import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/utility.dart';
import '../model/home_model.dart';

class SelectAuthorController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  Timer? _searchDebounce;

  RxString searchQuery = ''.obs;
  RxList<AllAuthorModel> welcomes = <AllAuthorModel>[].obs;
  RxBool isFetchHome = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> loadAllData() async {
    isFetchHome.value = true;
    await Future.wait([fetchHomeData()]);
    isFetchHome.value = false;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      fetchHomeData();
    });
  }

  List<AllAuthorModel> get filteredAuthors {
    if (searchQuery.value.trim().isEmpty) return welcomes;
    final query = searchQuery.value.toLowerCase().trim();
    return welcomes
        .where((author) => author.fullName.toLowerCase().contains(query))
        .toList();
  }

  Future<void> fetchHomeData() async {
    try {
      isFetchHome.value = true;
      errorMessage.value = '';

      final query = searchQuery.value.trim();
      final String endpoint =
          '${ApiEndPoints.allAuthor}${Uri.encodeQueryComponent(query)}';
      final response = await BaseService().baseGetAPI(endpoint, loading: false);

      if (response['success'] == true) {
        final dynamic rawData = response['data'] ?? response;

        final List<dynamic> items = rawData is List
            ? rawData
            : (rawData is Map && rawData['data'] is List
                  ? rawData['data'] as List
                  : const []);

        welcomes.assignAll(
          items
              .map((e) => AllAuthorModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to load authors';
        Utils.showToast(errorMessage.value, true);
      }
    } catch (e) {
      debugPrint('fetchHomeData error: $e');
      errorMessage.value = 'Something went wrong while loading authors';
      Utils.showToast(errorMessage.value, true);
    } finally {
      isFetchHome.value = false;
    }
  }

  // Future<void> fetchHomeData() async {
  //   try {
  //     isFetchHome.value = true;
  //     errorMessage.value = '';
  //
  //     final token =
  //         SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
  //     if (token.isEmpty) {
  //       errorMessage.value = 'Token not found';
  //       Utils.showToast('Please login again', true);
  //       return;
  //     }
  //
  //     final uri = Uri.parse(
  //       '${BaseService().baseURL}${ApiEndPoints.allAuthor}',
  //     );
  //     final response = await http.get(
  //       uri,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     if (response.statusCode >= 200 && response.statusCode < 300) {
  //       final responseBody = jsonDecode(response.body);
  //       final List<dynamic> items = responseBody is List
  //           ? responseBody
  //           : (responseBody is Map && responseBody['data'] is List
  //                 ? responseBody['data'] as List
  //                 : const []);
  //
  //       welcomes.assignAll(
  //         items
  //             .map((e) => AllAuthorModel.fromJson(e as Map<String, dynamic>))
  //             .toList(),
  //       );
  //     } else {
  //       final responseBody = jsonDecode(response.body);
  //       errorMessage.value =
  //           responseBody['message']?.toString() ?? 'Failed to load authors';
  //       Utils.showToast(errorMessage.value, true);
  //     }
  //   } catch (e) {
  //     errorMessage.value = 'Something went wrong while loading authors';
  //     Utils.showToast(errorMessage.value, true);
  //   } finally {
  //     isFetchHome.value = false;
  //     EasyLoading.dismiss();
  //   }
  // }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
