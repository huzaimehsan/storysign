import 'package:flutter/cupertino.dart';

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
  RxString sortBy = "None"
      .obs; // "None", "Title A-Z", "Title Z-A", "Date Newest", "Date Oldest"
  RxString filterStatus =
      "All".obs; // "All", "Signed", "In process", "Delivered", "Unsigned"

  RxBool isLibrary = false.obs;

  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxInt totalItems = 0.obs;
  RxBool isLoadingMore = false.obs;
  final ScrollController scrollController = ScrollController();

  var booksList = <BookItem>[].obs;
  late Rx<List<BookItem>> filteredBooksRx;
  RxString errorMessage = ''.obs;
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
    scrollController.addListener(_onScroll);

    // Fetch all books at once so local filtering works for all tabs
    fetchBooksData(status: 'all');
  }

  void _updateFilteredBooks() {
    filteredBooksRx.value = _getFilteredBooks();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 120 &&
        !isLoadingMore.value &&
        !isLibrary.value &&
        currentPage.value < totalPages.value) {
      currentPage.value++;
      fetchBooksData(status: _currentFetchStatus(), loadMore: true);
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  String _currentFetchStatus() {
    if (filterStatus.value != 'All') {
      return filterStatus.value.toLowerCase();
    }

    if (selectedTab.value == 'Signed') {
      return 'signed';
    } else if (selectedTab.value == 'Unsigned') {
      return 'unsigned';
    }

    return 'all';
  }

  List<BookItem> _getFilteredBooks() {
    List<BookItem> books = List<BookItem>.from(booksList);

    // 1. Filter by Tab selection ("All", "Signed", "Unsigned")
    if (selectedTab.value == "Signed") {
      books = books.where((book) {
        final status = book.status.toLowerCase().replaceAll(' ', '_');
        return status == "signed" ||
            status == "completed" ||
            status == "approved" ||
            status == "delivered";
      }).toList();
    } else if (selectedTab.value == "Unsigned") {
      books = books.where((book) {
        final status = book.status.toLowerCase().replaceAll(' ', '_');
        return status == "unsigned" || status == "pending";
      }).toList();
    }

    // 2. Filter by filterStatus dropdown
    if (filterStatus.value != "All") {
      final target = filterStatus.value.toLowerCase();
      books = books.where((book) {
        final status = book.status.toLowerCase().replaceAll(' ', '_');
        if (target == "signed") {
          return status == "signed" ||
              status == "completed" ||
              status == "approved" ||
              status == "delivered";
        } else if (target == "unsigned") {
          return status == "unsigned" || status == "pending";
        }
        return status == target;
      }).toList();
    }

    // 3. Filter by search query
    if (searchQuery.value.trim().isNotEmpty) {
      final query = searchQuery.value.toLowerCase().trim();
      books = books.where((book) {
        return book.title.toLowerCase().contains(query);
      }).toList();
    }

    // 4. Sort books
    if (sortBy.value == "Title A-Z") {
      books.sort((a, b) => a.title.compareTo(b.title));
    } else if (sortBy.value == "Title Z-A") {
      books.sort((a, b) => b.title.compareTo(a.title));
    } else if (sortBy.value == "Date Newest") {
      books.sort(
        (a, b) => _parseDate(b.uploadDate).compareTo(_parseDate(a.uploadDate)),
      );
    } else if (sortBy.value == "Date Oldest") {
      books.sort(
        (a, b) => _parseDate(a.uploadDate).compareTo(_parseDate(b.uploadDate)),
      );
    }

    return books;
  }

  List<BookItem> get filteredBooks {
    // Explicitly access all observables so Obx() tracks them
    final allBooks = booksList.toList();
    final tab = selectedTab.value;
    final query = searchQuery.value;
    final status = filterStatus.value;
    final sort = sortBy.value;

    List<BookItem> books = List<BookItem>.from(allBooks);

    // 1. Filter by Tab (All / Signed / Unsigned)
    if (tab == "Signed") {
      books = books.where((book) {
        final st = book.status.toLowerCase().replaceAll(' ', '_');
        return st == "signed" ||
            st == "completed" ||
            st == "approved" ||
            st == "delivered";
      }).toList();
    } else if (tab == "Unsigned") {
      books = books.where((book) {
        final st = book.status.toLowerCase().replaceAll(' ', '_');
        return st == "unsigned" || st == "pending";
      }).toList();
    }

    // 2. Filter by filterStatus dropdown
    if (status != "All") {
      final target = status.toLowerCase();
      books = books.where((book) {
        final st = book.status.toLowerCase().replaceAll(' ', '_');
        if (target == "signed") {
          return st == "signed" ||
              st == "completed" ||
              st == "approved" ||
              st == "delivered";
        } else if (target == "unsigned") {
          return st == "unsigned" || st == "pending";
        }
        return st == target;
      }).toList();
    }

    // 3. Filter by search query
    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      books = books
          .where((book) => book.title.toLowerCase().contains(q))
          .toList();
    }

    // 4. Sort books
    if (sort == "Title A-Z") {
      books.sort((a, b) => a.title.compareTo(b.title));
    } else if (sort == "Title Z-A") {
      books.sort((a, b) => b.title.compareTo(a.title));
    } else if (sort == "Date Newest") {
      books.sort(
        (a, b) => _parseDate(b.uploadDate).compareTo(_parseDate(a.uploadDate)),
      );
    } else if (sort == "Date Oldest") {
      books.sort(
        (a, b) => _parseDate(a.uploadDate).compareTo(_parseDate(b.uploadDate)),
      );
    }

    return books;
  }

  void selectTab(String tab) {
    selectedTab.value = tab;
    // Re-fetch data based on selected tab
    if (tab == "All") {
      fetchBooksData(status: 'all');
    } else if (tab == "Signed") {
      fetchBooksData(status: 'signed');
    } else if (tab == "Unsigned") {
      fetchBooksData(status: 'unsigned');
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
          'january': 1,
          'jan': 1,
          'february': 2,
          'feb': 2,
          'march': 3,
          'mar': 3,
          'april': 4,
          'apr': 4,
          'may': 5,
          'june': 6,
          'jun': 6,
          'july': 7,
          'jul': 7,
          'august': 8,
          'aug': 8,
          'september': 9,
          'sep': 9,
          'october': 10,
          'oct': 10,
          'november': 11,
          'nov': 11,
          'december': 12,
          'dec': 12,
        };
        final month = months[monthStr] ?? 1;
        return DateTime(year, month, day);
      }
    } catch (_) {}
    return DateTime.now();
  }

  Future<void> refreshRequests() async {
    currentPage.value = 1;
    await fetchBooksData(status: _currentFetchStatus());
  }

  Future<void> fetchBooksData({
    String status = 'all',
    bool loadMore = false,
  }) async {
    try {
      if (loadMore) {
        isLoadingMore.value = true;
      } else {
        isLibrary.value = true;
        booksList.clear(); // Clear previous data
        errorMessage.value = ''; // clear on fresh load
      }

      final token =
          SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
      if (token.isEmpty) {
        Utils.showToast('Please login again', true);
        return;
      }

      await _fetchBooksWithStatus(status, loadMore: loadMore);
    } catch (e) {
      errorMessage.value = 'Something went wrong: $e';
      Utils.showToast(errorMessage.value, true);
    } finally {
      if (loadMore) {
        isLoadingMore.value = false;
      } else {
        isLibrary.value = false;
      }
    }
  }

  Future<void> _fetchBooksWithStatus(
    String status, {
    bool loadMore = false,
  }) async {
    try {
      final Map<String, String> queryParams = {
        'page': currentPage.value.toString(),
        'limit': '10',
      };

      if (status != 'all') {
        queryParams['status'] = status;
      }

      final queryString = Uri(queryParameters: queryParams).query;
      final endpoint = '${ApiEndPoints.listMyBook}?$queryString';

      debugPrint('DEBUG: API Endpoint: $endpoint');

      final response = await BaseService().baseGetAPI(endpoint, loading: false);

      debugPrint('DEBUG: Response: $response');

      if (response['success'] == true) {
        final BookResponseModel model = BookResponseModel.fromJson(response);
        debugPrint('DEBUG: Parsed ${model.items.length} books');

        if (loadMore) {
          booksList.addAll(model.items);
        } else {
          booksList.assignAll(model.items);
        }

        currentPage.value = model.page;
        totalPages.value = model.totalPages;
        totalItems.value = model.total;

        debugPrint('DEBUG: Total books after adding: ${booksList.length}');
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to load books';
        Utils.showToast(errorMessage.value, true);
      }
    } catch (e) {
      errorMessage.value = 'Error fetching books: $e';
      debugPrint('Exception in _fetchBooksWithStatus: $e');
    }
  }

  // Future<void> _fetchBooksWithStatus(String status) async {
  //   try {
  //     final token = SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
  //     if (token.isEmpty) {
  //       print('DEBUG: Token is empty');
  //       return;
  //     }
  //
  //     final baseUrl = '${BaseService().baseURL}${ApiEndPoints.listMyBook}';
  //
  //     // Build query parameters - only add status if it's valid (signed or unsigned)
  //     final Map<String, String> queryParams = {
  //       'page': '1',
  //       'limit': '10',
  //     };
  //
  //     // Only add status if it's signed or unsigned (not 'all')
  //     if (status == 'signed' || status == 'unsigned') {
  //       queryParams['status'] = status;
  //     }
  //
  //     final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
  //     print('DEBUG: API URL: $uri');
  //
  //     final response = await http.get(
  //       uri,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     print('DEBUG: Status Code: ${response.statusCode}');
  //     print('DEBUG: Response Body: ${response.body}');
  //
  //     if (response.statusCode >= 200 && response.statusCode < 300) {
  //       final responseBody = jsonDecode(response.body);
  //       print('DEBUG: Decoded Response: $responseBody');
  //
  //       if (responseBody['items'] != null) {
  //         final BookResponseModel model = BookResponseModel.fromJson(responseBody);
  //         print('DEBUG: Parsed ${model.items.length} books');
  //         booksList.addAll(model.items);
  //         print('DEBUG: Total books after adding: ${booksList.length}');
  //       } else if (responseBody['message'] != null) {
  //         Utils.showToast(responseBody['message'], false);
  //       }
  //     } else {
  //       try {
  //         final errorBody = jsonDecode(response.body);
  //         final errorMsg = errorBody['message'] ?? 'Failed to load books: ${response.statusCode}';
  //         Utils.showToast(errorMsg, true);
  //       } catch (_) {
  //         Utils.showToast('Failed to load books: ${response.statusCode}', true);
  //       }
  //     }
  //   } catch (e) {
  //     print('DEBUG: Exception: $e');
  //     Utils.showToast('Error: $e', true);
  //   }
  // }
}
