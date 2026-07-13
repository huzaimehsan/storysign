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
import '../model/home_model.dart';

class HomeController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }
  RxString selectedTab = "All".obs;

  final TextEditingController bookTitleController = TextEditingController();
  final Rxn<File> bookPdfFile = Rxn<File>();
  final Rxn<File> bookCoverImage = Rxn<File>();

  RxInt selectedAuthorIndex = 0.obs;

  var authors = <Map<String, dynamic>>[
    {
      "name": "James Davenport",
      "imagePath": "assets/png/authorimg.png",
      "date": "Joined: 22 june, 2026",
      "active": true,
    },
    {
      "name": "Jane Austen",
      "imagePath": "assets/png/authorimg1.png",
      "date": "Joined: 22 june, 2026",
      "active": true,
    },
    {
      "name": "F. Scott Fitzgerald",
      "imagePath": "assets/png/authorimg2.png",
      "date": "Joined: 22 june, 2026",
      "active": true,
    },
    {
      "name": "William Shakespeare",
      "imagePath": "assets/png/authorimg3.png",
      "date": "Joined: 22 june, 2026",
      "active": false,
    },
    {
      "name": "Leo Tolstoy",
      "imagePath": "assets/png/authorimg4.png",
      "date": "Joined: 22 june, 2026",
      "active": true,
    },
  ].obs;

  var recentlySignedBooksList = <Map<String, String>>[
    {
      "imagePath": "assets/png/book.png",
      "bookTitle": "Pride and Prejudice",
      "authorName": "Jane Austen",
      "date": "22 june, 2026",
      "status": "Signed",
    },
    {
      "imagePath": "assets/png/book.png",
      "bookTitle": "The Great Gatsby",
      "authorName": "F. Scott Fitzgerald",
      "date": "25 june, 2026",
      "status": "In process",
    },
    {
      "imagePath": "assets/png/book.png",
      "bookTitle": "The Great Gatsby",
      "authorName": "F. Scott Fitzgerald",
      "date": "25 june, 2026",
      "status": "Delivered",
    },


  ].obs;

  RxString searchQuery = "".obs;
  RxList<AllAuthorModel> welcomes = <AllAuthorModel>[].obs;
  Rxn<AuthorDetailModel> authorDetailData = Rxn<AuthorDetailModel>();
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  List<Map<String, dynamic>> get filteredAuthors {
    if (searchQuery.value.trim().isEmpty) {
      return authors;
    }
    final query = searchQuery.value.toLowerCase();
    return authors
        .where((author) =>
            (author["name"] as String).toLowerCase().contains(query))
        .toList();
  }

  List<Map<String, String>> get filteredRecentlySignedBooks {
    final query = searchQuery.value.toLowerCase().trim();

    return recentlySignedBooksList.where((book) {
      final status = book["status"] ?? "";
      final matchesTab = selectedTab.value == "All" ||
          (selectedTab.value == "In Process" && status == "In process") ||
          (selectedTab.value == "Delivered" && status == "Delivered");

      if (!matchesTab) return false;

      if (query.isEmpty) return true;

      final title = (book["bookTitle"] ?? "").toLowerCase();
      final author = (book["authorName"] ?? "").toLowerCase();
      return title.contains(query) || author.contains(query);
    }).toList();
  }

  void selectAuthor(int index) {
    selectedAuthorIndex.value = index;
  }

  void selectTab(String tab) {
    selectedTab.value = tab;
  }

  void applyFilter(String tab) {
    selectTab(tab);
  }

  void resetFilter() {
    selectTab("All");
  }

  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      EasyLoading.show(status: 'Please wait...', maskType: EasyLoadingMaskType.black);

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
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }



  //---------------------------------------------------------------------------//
// upload book function //


  Future<void> uploadBook(BuildContext context) async {
    final String title = bookTitleController.text.trim();

    if (title.isEmpty) {
      Utils.showToast('Book title is required', true);
      return;
    }

    if (bookPdfFile.value == null || !bookPdfFile.value!.existsSync()) {
      Utils.showToast('PDF file is required', true);
      return;
    }

    if (bookCoverImage.value == null || !bookCoverImage.value!.existsSync()) {
      Utils.showToast('Cover image is required', true);
      return;
    }

    try {
      EasyLoading.show(
        status: 'Uploading book...',
        maskType: EasyLoadingMaskType.black,
      );

      final uri = Uri.parse('${BaseService().baseURL}${ApiEndPoints.uploadBook}');
      final request = http.MultipartRequest('POST', uri);

      // Agar auth token chahiye header mein
      final token = SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN);
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields['title'] = title;

      // PDF file
      final pdfFile = bookPdfFile.value!;
      request.files.add(await http.MultipartFile.fromPath(
        'bookPdf',
        pdfFile.path,
        filename: pdfFile.path.split('/').last,
        contentType: http.MediaType('application', 'pdf'),
      ));

      // Cover image
      final coverFile = bookCoverImage.value!;
      request.files.add(await http.MultipartFile.fromPath(
        'coverImage',
        coverFile.path,
        filename: coverFile.path.split('/').last,
        contentType: http.MediaType('image', 'png'), // agar jpg ho to 'jpeg' kar dein
      ));

      print('⏳ UPLOAD BOOK API CALLING: $uri');
      print('➡ Fields: ${request.fields}');

      final streamedResponse = await request.send().timeout(const Duration(seconds: 60));
      final responseString = await streamedResponse.stream.bytesToString();
      final responseMap = json.decode(responseString);

      print('✅ RESPONSE: $responseMap');

      if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201) {
        Utils.showToast(responseMap['message'] ?? 'Book uploaded successfully', false);
        clearUploadBookFields();
        Get.back(); // ya jahan navigate karna hai
        return;
      }

      Utils.showToast(responseMap['message'] ?? 'Book upload failed', true);
    } on TimeoutException {
      Utils.showToast('Request timed out', true);
    } on SocketException {
      Utils.showToast('No Internet connection', true);
    } catch (e) {
      print('Upload Book Error: $e');
      Utils.showToast('Unexpected error: $e', true);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void clearUploadBookFields() {
    bookTitleController.clear();
    bookPdfFile.value = null;
    bookCoverImage.value = null;
  }


}