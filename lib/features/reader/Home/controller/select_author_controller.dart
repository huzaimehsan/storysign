import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';
import '../model/home_model.dart';

class SelectAuthorController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  RxString searchQuery = ''.obs;
  RxList<AllAuthorModel> welcomes = <AllAuthorModel>[].obs;
  RxBool isFetchHome = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
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

      final token =
          SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
      if (token.isEmpty) {
        errorMessage.value = 'Token not found';
        Utils.showToast('Please login again', true);
        return;
      }

      final uri = Uri.parse(
        '${BaseService().baseURL}${ApiEndPoints.allAuthor}',
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
        final List<dynamic> items = responseBody is List
            ? responseBody
            : (responseBody is Map && responseBody['data'] is List
                  ? responseBody['data'] as List
                  : const []);

        welcomes.assignAll(
          items
              .map((e) => AllAuthorModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      } else {
        final responseBody = jsonDecode(response.body);
        errorMessage.value =
            responseBody['message']?.toString() ?? 'Failed to load authors';
        Utils.showToast(errorMessage.value, true);
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong while loading authors';
      Utils.showToast(errorMessage.value, true);
    } finally {
      isFetchHome.value = false;
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
