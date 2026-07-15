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
    debugPrint("HomeController onInit called");
    Future.delayed(Duration(milliseconds: 500), () {
      fetchTrackRequestData();
    });
  }

  RxString selectedTab = "All".obs;

  final TextEditingController bookTitleController = TextEditingController();
  final TextEditingController bookTitleControllerRequest =
      TextEditingController();
  final TextEditingController personalMessageController =
      TextEditingController();

  RxList<BookItem> trackRequest = <BookItem>[].obs;
  final Rxn<File> bookPdfFile = Rxn<File>();
  final Rxn<File> bookCoverImage = Rxn<File>();

  RxInt selectedAuthorIndex = 0.obs;

  // HomeController mein
  RxString selectedAuthorId = "".obs;

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

  RxBool trackRequestLoading = false.obs;
  RxBool isFetchHome = false.obs;
  RxString errorMessage = ''.obs;

  List<AllAuthorModel> get filteredAuthors {
    if (searchQuery.value.trim().isEmpty) {
      return welcomes;
    }
    final query = searchQuery.value.toLowerCase().trim();
    return welcomes
        .where((author) => author.fullName.toLowerCase().contains(query))
        .toList();
  }

  List<Map<String, String>> get filteredRecentlySignedBooks {
    final query = searchQuery.value.toLowerCase().trim();

    return recentlySignedBooksList.where((book) {
      final status = book["status"] ?? "";
      final matchesTab =
          selectedTab.value == "All" ||
          (selectedTab.value == "In Process" && status == "In process") ||
          (selectedTab.value == "Delivered" && status == "Delivered");

      if (!matchesTab) return false;

      if (query.isEmpty) return true;

      final title = (book["bookTitle"] ?? "").toLowerCase();
      final author = (book["authorName"] ?? "").toLowerCase();
      return title.contains(query) || author.contains(query);
    }).toList();
  }

  // -----------------------------------------------------------------------------------------//
  RxString sortBy = "None"
      .obs; // "None", "Title A-Z", "Title Z-A", "Date Newest", "Date Oldest"
  RxString filterStatus =
      "All".obs; // "All", "In process", "Delivered", "Signed", "Unsigned"

  // ye helper method bhi add karein (class ke andar kahin bhi):
  DateTime _parseDate(String dateStr) {
    try {
      final parsed = DateTime.tryParse(dateStr);
      if (parsed != null) return parsed;
    } catch (_) {}
    return DateTime.now();
  }

  // filteredBooks getter POORI TARAH HATA DEIN (booksList declare hi nahi hai yahan)

  // filteredTrackRequest ko is se replace karein:
  List<BookItem> get filteredTrackRequest {
    List<BookItem> requests = List<BookItem>.from(trackRequest);

    // 1. Tab filter (All / In Process / Delivered)
    if (selectedTab.value == "In Process") {
      requests = requests.where((item) => item.status == "In process").toList();
    } else if (selectedTab.value == "Delivered") {
      requests = requests.where((item) => item.status == "Delivered").toList();
    }

    // 2. Search query
    if (searchQuery.value.trim().isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      requests = requests.where((item) {
        final title = item.title.toLowerCase();
        final author = item.author.fullName.toLowerCase();
        return title.contains(query) || author.contains(query);
      }).toList();
    }

    // 3. Status filter (dropdown se)
    if (filterStatus.value != "All") {
      requests = requests
          .where((item) => item.status == filterStatus.value)
          .toList();
    }

    // 4. Sort
    if (sortBy.value == "Title A-Z") {
      requests.sort((a, b) => a.title.compareTo(b.title));
    } else if (sortBy.value == "Title Z-A") {
      requests.sort((a, b) => b.title.compareTo(a.title));
    } else if (sortBy.value == "Date Newest") {
      requests.sort(
        (a, b) => _parseDate(b.uploadDate).compareTo(_parseDate(a.uploadDate)),
      );
    } else if (sortBy.value == "Date Oldest") {
      requests.sort(
        (a, b) => _parseDate(a.uploadDate).compareTo(_parseDate(b.uploadDate)),
      );
    }

    return requests;
  }

  // resetFilter ko bhi update kar dein taake sort/filter bhi reset ho:
  void resetFilter() {
    selectTab("All");
    sortBy.value = "None";
    filterStatus.value = "All";
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

  Future<void> fetchHomeData() async {
    try {
      isFetchHome.value = true;
      errorMessage.value = '';
      // EasyLoading.show(status: 'Please wait...', maskType: EasyLoadingMaskType.black);

      final prefs = SharedPreferencesMethod.storage;
      final token = prefs.getString(LocalDBKeys.TOKEN) ?? '';

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
            responseBody['message']?.toString() ?? 'Failed to load home data';
        Utils.showToast(errorMessage.value, true);
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong while loading data';
      Utils.showToast(errorMessage.value, true);
    } finally {
      isFetchHome.value = false;
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
        final dynamic data = decodedBody is Map
            ? (decodedBody['data'] ?? decodedBody)
            : null;

        if (data is Map) {
          authorDetailData.value = AuthorDetailModel.fromJson(
            Map<String, dynamic>.from(data),
          );
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

      final uri = Uri.parse(
        '${BaseService().baseURL}${ApiEndPoints.uploadBook}',
      );
      final request = http.MultipartRequest('POST', uri);

      // Agar auth token chahiye header mein
      final token = SharedPreferencesMethod.storage.getString(
        LocalDBKeys.TOKEN,
      );
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields['title'] = title;

      // PDF file
      final pdfFile = bookPdfFile.value!;
      request.files.add(
        await http.MultipartFile.fromPath(
          'bookPdf',
          pdfFile.path,
          filename: pdfFile.path.split('/').last,
          contentType: http.MediaType('application', 'pdf'),
        ),
      );

      // Cover image
      final coverFile = bookCoverImage.value!;
      request.files.add(
        await http.MultipartFile.fromPath(
          'coverImage',
          coverFile.path,
          filename: coverFile.path.split('/').last,
          contentType: http.MediaType(
            'image',
            'png',
          ), // agar jpg ho to 'jpeg' kar dein
        ),
      );

      print('â³ UPLOAD BOOK API CALLING: $uri');
      print('âž¡ Fields: ${request.fields}');

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      );
      final responseString = await streamedResponse.stream.bytesToString();
      final responseMap = json.decode(responseString);

      print('âœ… RESPONSE: $responseMap');

      if (streamedResponse.statusCode == 200 ||
          streamedResponse.statusCode == 201) {
        Utils.showToast(
          responseMap['message'] ?? 'Book uploaded successfully',
          false,
        );
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

  Future<String?> requestAutograph(BuildContext context, String authorId) async {
    final String title = bookTitleControllerRequest.text.trim();
    final String personalMessage = personalMessageController.text.trim();

    if (authorId.isEmpty) {
      Utils.showToast('Author ID is required', true);
  
    }

    if (title.isEmpty) {
      Utils.showToast('Book title is required', true);
 
    }

    if (bookPdfFile.value == null || !bookPdfFile.value!.existsSync()) {
      Utils.showToast('PDF file is required', true);

    }

    if (bookCoverImage.value == null || !bookCoverImage.value!.existsSync()) {
      Utils.showToast('Cover image is required', true);
    
    }

    try {
      EasyLoading.show(
        status: 'Sending autograph request...',
        maskType: EasyLoadingMaskType.black,
      );

      final uri = Uri.parse(
        '${BaseService().baseURL}/reader/autograph-requests',
      );
      final request = http.MultipartRequest('POST', uri);

      // Auth token header mein
      final token = SharedPreferencesMethod.storage.getString(
        LocalDBKeys.TOKEN,
      );
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Text fields
      request.fields['authorId'] = authorId;
      request.fields['bookTitle'] = title;
      request.fields['personalMessage'] = personalMessage;

      // PDF file
      final pdfFile = bookPdfFile.value!;
      request.files.add(
        await http.MultipartFile.fromPath(
          'bookPdf',
          pdfFile.path,
          filename: pdfFile.path.split('/').last,
          contentType: http.MediaType('application', 'pdf'),
        ),
      );

      // Cover image
      final coverFile = bookCoverImage.value!;
      request.files.add(
        await http.MultipartFile.fromPath(
          'coverImage',
          coverFile.path,
          filename: coverFile.path.split('/').last,
          contentType: http.MediaType(
            'image',
            'png',
          ), // jpg ho to 'jpeg' kar dein
        ),
      );

      print(' AUTOGRAPH REQUEST API CALLING: $uri');
      print(' Fields: ${request.fields}');

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      );
      final responseString = await streamedResponse.stream.bytesToString();
      final responseMap = json.decode(responseString);

      print('RESPONSE: $responseMap');

      if (streamedResponse.statusCode == 200 ||
          streamedResponse.statusCode == 201) {
        Utils.showToast(
          responseMap['message'] ?? 'Autograph request sent successfully',
          false,
        );
        clearRequestBookFields();
        Get.toNamed('/request');
       
      }

      Utils.showToast(
        responseMap['message'] ?? 'Autograph request failed',
        true,
      );
    } on TimeoutException {
      Utils.showToast('Request timed out', true);
    } on SocketException {
      Utils.showToast('No Internet connection', true);
    } catch (e) {
      print('Autograph Request Error: $e');
      Utils.showToast('Unexpected error: $e', true);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void clearRequestBookFields() {
    bookTitleControllerRequest.clear();
    personalMessageController.clear();

    bookPdfFile.value = null;
    bookCoverImage.value = null;
  }

  ///////////////////////////////////////
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxInt totalItems = 0.obs;

  Future<void> fetchTrackRequestData() async {
    try {
      trackRequestLoading.value = true;
      errorMessage.value = '';

      await Future.delayed(const Duration(milliseconds: 500));

      final prefs = SharedPreferencesMethod.storage;
      final token = prefs.getString(LocalDBKeys.TOKEN) ?? '';

      if (token.isEmpty) {
        errorMessage.value = 'Token not found';
        Utils.showToast('Please login again', true);
        return;
      }

      final uri = Uri.parse(
        '${BaseService().baseURL}${ApiEndPoints.trackRequest}',
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

        // Poora response TrackRequest model se parse karo (items + pagination sab)
        final Map<String, dynamic> data =
            responseBody is Map && responseBody['data'] is Map
            ? responseBody['data']
            : responseBody;

        final trackRequestData = TrackRequestModel.fromJson(data);

        trackRequest.assignAll(trackRequestData.items);
        currentPage.value = trackRequestData.page;
        totalPages.value = trackRequestData.totalPages;
        totalItems.value = trackRequestData.total;
      } else {
        final responseBody = jsonDecode(response.body);
        errorMessage.value =
            responseBody['message']?.toString() ?? 'Failed to load data';
        Utils.showToast(errorMessage.value, true);
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong while loading data: $e';
      debugPrint('fetchTrackRequestData error: $e');
      Utils.showToast(errorMessage.value, true);
    } finally {
      trackRequestLoading.value = false;
      debugPrint("Loader ab ${trackRequestLoading.value} hai");

      debugPrint("Loader ab ${trackRequestLoading.value} hai");
    }
  }
}

