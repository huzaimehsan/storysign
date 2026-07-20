import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';
import '../../Home/model/home_model.dart';



class SearchPageController extends GetxController {
  late String authorId;
  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }


  Future<void> refreshSearchRequests() async {
    // Apni wahi API call yahan dobara call karein jo data fetch karti hai
    fetchHomeData();
  }
  RxList<AllAuthorModel> welcomes = <AllAuthorModel>[].obs;
  Rxn<AuthorDetailModel> authorDetailData = Rxn<AuthorDetailModel>();
  RxBool isLoading = false.obs;       // for list loading (search screen)
  RxBool isDetailLoading = false.obs; // for author detail loading
  RxString errorMessage = ''.obs;
  var authors = <Map<String, String>>[
    {
      "imagePath": "assets/png/searchprofile.png",
      "bookTitle": "Matt Haig",
      "date": "Joined: 22 june, 2026",
    },
    {
      "imagePath": "assets/png/searchprofile.png",
      "bookTitle": "James Davenport",
      "date": "Joined: 15 june, 2026",
    },
    {
      "imagePath": "assets/png/searchprofile.png",
      "bookTitle": "Jane Austen",
      "date": "Joined: 18 june, 2026",
    },
    {
      "imagePath": "assets/png/searchprofile.png",
      "bookTitle": "F. Scott Fitzgerald",
      "date": "Joined: 20 june, 2026",
    },
    {
      "imagePath": "assets/png/searchprofile.png",
      "bookTitle": "Jane Austen",
      "date": "Joined: 18 june, 2026",
    },
    {
      "imagePath": "assets/png/searchprofile.png",
      "bookTitle": "Jane Austen",
      "date": "Joined: 18 june, 2026",
    },
    {
      "imagePath": "assets/png/searchprofile.png",
      "bookTitle": "Jane Austen",
      "date": "Joined: 18 june, 2026",
    },
    {
      "imagePath": "assets/png/searchprofile.png",
      "bookTitle": "William Shakespeare",
      "date": "Joined: 10 june, 2026",
    },
  ].obs;

  RxString searchQuery = "".obs;

  List<AllAuthorModel> get filteredAuthors {
    if (searchQuery.value.trim().isEmpty) {
      return welcomes;
    }
    final query = searchQuery.value.toLowerCase().trim();
    return welcomes
        .where((author) => author.fullName.toLowerCase().contains(query))
        .toList();
  }



  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      // EasyLoading.show(status: 'Please wait...', maskType: EasyLoadingMaskType.black);

      final prefs = SharedPreferencesMethod.storage;
      final token = prefs.getString(LocalDBKeys.TOKEN) ?? '';

      if (token.isEmpty) {
        errorMessage.value = 'Token not found';
        Utils.showToast('Please login again', true);
        return;
      }

      final uri = Uri.parse('${BaseService().baseURL}${ApiEndPoints.allAuthor}');
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

        welcomes.assignAll(items.map((e) => AllAuthorModel.fromJson(e as Map<String, dynamic>)).toList());
      } else {
        final responseBody = jsonDecode(response.body);
        errorMessage.value = responseBody['message']?.toString() ?? 'Failed to load home data';
        Utils.showToast(errorMessage.value, true);
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong while loading data';
      Utils.showToast(errorMessage.value, true);
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  Future<void> authorDetail(String? authorId) async {
    try {
      isDetailLoading.value = true;
      errorMessage.value = '';

      final prefs = SharedPreferencesMethod.storage;
      final token = prefs.getString(LocalDBKeys.TOKEN) ?? '';

      if (token.isEmpty) {
        errorMessage.value = 'Token not found';
        Utils.showToast('Please login again', true);
        return;
      }

      final cleanedId = authorId?.trim();
      final endpoint = cleanedId != null && cleanedId.isNotEmpty
          ? '${ApiEndPoints.authorDetail}/${Uri.encodeComponent(cleanedId)}'
          : ApiEndPoints.authorDetail;

      final uri = Uri.parse('${BaseService().baseURL}$endpoint');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final dynamic decodedBody = jsonDecode(response.body);
        final dynamic data = decodedBody is Map ? (decodedBody['data'] ?? decodedBody) : null;

        if (data is Map) {
          authorDetailData.value = AuthorDetailModel.fromJson(Map<String, dynamic>.from(data));
          debugPrint('Success! Author ID: ${authorDetailData.value?.id}');
        } else {
          errorMessage.value = 'Invalid author detail response';
          Utils.showToast(errorMessage.value, true);
        }
      } else {
        String message = 'Failed to load author detail';
        try {
          final responseBody = jsonDecode(response.body);
          message = responseBody['message']?.toString() ?? message;
        } catch (_) {}
        errorMessage.value = message;
        Utils.showToast(message, true);
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong while loading data: $e';
      debugPrint('HomeController authorDetail error: $e');
      Utils.showToast(errorMessage.value, true);
    } finally {
      isDetailLoading.value = false;
      EasyLoading.dismiss();
    }
  }
}
