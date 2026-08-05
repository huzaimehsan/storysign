import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
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

      final response = await BaseService().baseGetAPI(
        ApiEndPoints.allAuthor,
        loading: false,
        showErrorToast: false,
      );

      if (response['success'] == true) {
        final dynamic payload = response['data'] ?? response;
        final List<dynamic> items = payload is List
            ? payload
            : (payload is Map && payload['data'] is List
                ? payload['data'] as List
                : const []);

        welcomes.assignAll(
          items
              .map((e) => AllAuthorModel.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList(),
        );
      } else {
        errorMessage.value = response['message']?.toString() ?? 'Failed to load home data';
        Utils.showToast(errorMessage.value, true);
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong while loading data';
      Utils.showToast(errorMessage.value, true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> authorDetail(String? authorId) async {
    try {
      isDetailLoading.value = true;
      errorMessage.value = '';

      final cleanedId = authorId?.trim();
      final endpoint = cleanedId != null && cleanedId.isNotEmpty
          ? '${ApiEndPoints.authorDetail}/${Uri.encodeComponent(cleanedId)}'
          : ApiEndPoints.authorDetail;

      final response = await BaseService().baseGetAPI(
        endpoint,
        loading: false,
        showErrorToast: false,
      );

      if (response['success'] == true) {
        final dynamic data = response['data'] ?? response;
        if (data is Map) {
          authorDetailData.value = AuthorDetailModel.fromJson(Map<String, dynamic>.from(data));
          debugPrint('Success! Author ID: ${authorDetailData.value?.id}');
        } else {
          errorMessage.value = 'Invalid author detail response';
          Utils.showToast(errorMessage.value, true);
        }
      } else {
        errorMessage.value = response['message']?.toString() ?? 'Failed to load author detail';
        Utils.showToast(errorMessage.value, true);
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong while loading data';
      debugPrint('SearchPageController authorDetail error: $e');
      Utils.showToast(errorMessage.value, true);
    } finally {
      isDetailLoading.value = false;
    }
  }
}
