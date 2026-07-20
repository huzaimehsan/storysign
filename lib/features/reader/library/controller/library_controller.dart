import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';
import '../model/library_model.dart';

class ReaderController extends GetxController {
  RxString selectedTab = "All".obs;
  RxString searchQuery = "".obs;
  RxString sortBy = "None".obs; // "None", "Title A-Z", "Title Z-A", "Date Newest", "Date Oldest"
  RxString filterStatus = "All".obs; // "All", "Signed", "In process", "Delivered", "Unsigned"

  RxBool isLibrary = false.obs;

  var booksList = <BookItem>[].obs;
  late Rx<List<BookItem>> filteredBooksRx;

  @override
  void onInit() {
    super.onInit();
    // Create reactive computed value
    filteredBooksRx = Rx<List<BookItem>>([]);

    // Listen to changes and update filtered books
    ever(booksList, (_) => _updateFilteredBooks());
    ever(selectedTab, (_) => _updateFilteredBooks());
    ever(searchQuery, (_) => _updateFilteredBooks());
    ever(sortBy, (_) => _updateFilteredBooks());
    ever(filterStatus, (_) => _updateFilteredBooks());

    fetchBooksData();
  }

  void _updateFilteredBooks() {
    filteredBooksRx.value = _getFilteredBooks();
  }

  List<BookItem> _getFilteredBooks() {
    List<BookItem> books = List<BookItem>.from(booksList);

    // Debug: Print raw data
    print('DEBUG: Total books in list: ${books.length}');
    print('DEBUG: Selected Tab: ${selectedTab.value}');

    // 1. Filter by Tab selection ("All", "Signed", "Unsigned")
    if (selectedTab.value == "Signed") {
      books = books.where((book) {
        final status = book.status.toLowerCase();
        return status == "signed" || status == "in process" || status == "delivered";
      }).toList();
    } else if (selectedTab.value == "Unsigned") {
      books = books.where((book) => book.status.toLowerCase() == "unsigned").toList();
    }

    // 2. Filter by search query
    if (searchQuery.value.trim().isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      books = books.where((book) {
        final title = book.title.toLowerCase();
        final author = book.id.toLowerCase();
        return title.contains(query) || author.contains(query);
      }).toList();
    }

    // 3. Sort books
    if (sortBy.value == "Title A-Z") {
      books.sort((a, b) => a.title.compareTo(b.title));
    } else if (sortBy.value == "Title Z-A") {
      books.sort((a, b) => b.title.compareTo(a.title));
    } else if (sortBy.value == "Date Newest") {
      books.sort((a, b) => _parseDate(b.uploadDate).compareTo(_parseDate(a.uploadDate)));
    } else if (sortBy.value == "Date Oldest") {
      books.sort((a, b) => _parseDate(a.uploadDate).compareTo(_parseDate(b.uploadDate)));
    }

    print('DEBUG: Filtered books count: ${books.length}');
    return books;
  }

  List<BookItem> get filteredBooks {
    return _getFilteredBooks();
  }


  void selectTab(String tab) {
    selectedTab.value = tab;
    // Fetch data based on selected tab
    if (tab == "All") {
      fetchBooksData(status: 'all');
    } else if (tab == "Signed") {
      fetchBooksData(status: 'signed');
    } else if (tab == "Unsigned") {
      fetchBooksData(status: 'unsigned');
    } else {
      // Default to signed
      fetchBooksData(status: 'signed');
    }
  }

  DateTime _parseDate(String dateStr) {
    try {
      final parsed = DateTime.tryParse(dateStr);
      if (parsed != null) return parsed;

      final parts = dateStr.toLowerCase().replaceAll(',', '').split(' ');
      if (parts.length >= 3) {
        final day = int.tryParse(parts[0]) ?? 1;
        final monthStr = parts[1];
        final year = int.tryParse(parts[2]) ?? 2026;

        final months = {
          'january': 1, 'jan': 1,
          'february': 2, 'feb': 2,
          'march': 3, 'mar': 3,
          'april': 4, 'apr': 4,
          'may': 5,
          'june': 6, 'jun': 6,
          'july': 7, 'jul': 7,
          'august': 8, 'aug': 8,
          'september': 9, 'sep': 9,
          'october': 10, 'oct': 10,
          'november': 11, 'nov': 11,
          'december': 12, 'dec': 12,
        };
        final month = months[monthStr] ?? 1;
        return DateTime(year, month, day);
      }
    } catch (_) {}
    return DateTime.now();
  }


  Future<void> refreshRequests() async {
    // Apni wahi API call yahan dobara call karein jo data fetch karti hai
    await fetchBooksData();
    await _fetchBooksWithStatus('all');
  }

  // 'status' parameter add karein (default 'signed' rakhein)
  Future<void> fetchBooksData({String status = 'signed'}) async {
    try {
      isLibrary.value = true;
      booksList.clear(); // Clear previous data

      final token = SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
      if (token.isEmpty) {
        Utils.showToast('Please login again', true);
        return;
      }

      // Handle 'all' status by fetching both signed and unsigned
      if (status == 'all') {
        await _fetchBooksWithStatus('signed');
        await _fetchBooksWithStatus('unsigned');
      } else if (status.isNotEmpty) {
        await _fetchBooksWithStatus(status);
      }
    } catch (e) {
      Utils.showToast('Something went wrong: $e', true);
    } finally {
      isLibrary.value = false;
    }
  }

  Future<void> _fetchBooksWithStatus(String status) async {
    try {
      final token = SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
      if (token.isEmpty) {
        print('DEBUG: Token is empty');
        return;
      }

      final baseUrl = '${BaseService().baseURL}${ApiEndPoints.listMyBook}';

      // Build query parameters - only add status if it's valid (signed or unsigned)
      final Map<String, String> queryParams = {
        'page': '1',
        'limit': '10',
      };

      // Only add status if it's signed or unsigned (not 'all')
      if (status == 'signed' || status == 'unsigned') {
        queryParams['status'] = status;
      }

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      print('DEBUG: API URL: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('DEBUG: Status Code: ${response.statusCode}');
      print('DEBUG: Response Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = jsonDecode(response.body);
        print('DEBUG: Decoded Response: $responseBody');

        if (responseBody['items'] != null) {
          final BookResponseModel model = BookResponseModel.fromJson(responseBody);
          print('DEBUG: Parsed ${model.items.length} books');
          booksList.addAll(model.items);
          print('DEBUG: Total books after adding: ${booksList.length}');
        } else if (responseBody['message'] != null) {
          Utils.showToast(responseBody['message'], false);
        }
      } else {
        try {
          final errorBody = jsonDecode(response.body);
          final errorMsg = errorBody['message'] ?? 'Failed to load books: ${response.statusCode}';
          Utils.showToast(errorMsg, true);
        } catch (_) {
          Utils.showToast('Failed to load books: ${response.statusCode}', true);
        }
      }
    } catch (e) {
      print('DEBUG: Exception: $e');
      Utils.showToast('Error: $e', true);
    }
  }
}
