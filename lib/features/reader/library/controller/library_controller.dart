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
  RxBool isLoading = false.obs;

  var booksList = <BookItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBooksData();
  }

  void selectTab(String tab) {
    selectedTab.value = tab;
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

  List<Map<String, String>> get filteredBooks {
    List<Map<String, String>> books = List.from(booksList.map((book) => {
      "bookTitle": book.title ?? "",
      "authorName": book.id ?? "",
      "date": book.uploadDate ?? "",
      "status": book..status ,
    }).toList());

    // 1. Filter by Tab selection ("All", "Signed", "Unsigned")
    if (selectedTab.value == "Signed") {
      books = books.where((book) {
        final status = book["status"] ?? "";
        return status == "Signed" || status == "In process" || status == "Delivered";
      }).toList();
    } else if (selectedTab.value == "Unsigned") {
      books = books.where((book) => book["status"] == "Unsigned").toList();
    }

    // 2. Filter by search query
    if (searchQuery.value.trim().isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      books = books.where((book) {
        final title = (book["bookTitle"] ?? "").toLowerCase();
        final author = (book["authorName"] ?? "").toLowerCase();
        return title.contains(query) || author.contains(query);
      }).toList();
    }

    // 3. Filter by filterStatus (from the tune filter dialog)
    if (filterStatus.value != "All") {
      books = books.where((book) => book["status"] == filterStatus.value).toList();
    }

    // 4. Sort books
    if (sortBy.value == "Title A-Z") {
      books.sort((a, b) => (a["bookTitle"] ?? "").compareTo(b["bookTitle"] ?? ""));
    } else if (sortBy.value == "Title Z-A") {
      books.sort((a, b) => (b["bookTitle"] ?? "").compareTo(a["bookTitle"] ?? ""));
    } else if (sortBy.value == "Date Newest") {
      books.sort((a, b) {
        final dateA = _parseDate(a["date"] ?? "");
        final dateB = _parseDate(b["date"] ?? "");
        return dateB.compareTo(dateA);
      });
    } else if (sortBy.value == "Date Oldest") {
      books.sort((a, b) {
        final dateA = _parseDate(a["date"] ?? "");
        final dateB = _parseDate(b["date"] ?? "");
        return dateA.compareTo(dateB);
      });
    }

    return books;
  }




  Future<void> fetchBooksData() async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Loading books...', maskType: EasyLoadingMaskType.black);

      final token = SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
      if (token.isEmpty) {
        Utils.showToast('Please login again', true);
        return;
      }


      final uri = Uri.parse('${BaseService().baseURL}${ApiEndPoints.listMyBook}');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = jsonDecode(response.body);
        print(responseBody);


        if (responseBody['items'] != null) {
          final BookResponseModel model = BookResponseModel.fromJson(responseBody);
          booksList.assignAll(model.items);
        }
      } else {
        Utils.showToast('Failed to load books', true);
      }
    } catch (e) {
      Utils.showToast('Something went wrong: $e', true);
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }
}
