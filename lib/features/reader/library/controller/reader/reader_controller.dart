import 'package:get/get.dart';

class ReaderController extends GetxController {
  RxString selectedTab = "All".obs;
  RxString searchQuery = "".obs;
  RxString sortBy = "None".obs; // "None", "Title A-Z", "Title Z-A", "Date Newest", "Date Oldest"
  RxString filterStatus = "All".obs; // "All", "Signed", "In process", "Delivered", "Unsigned"

  var libraryBooksList = <Map<String, String>>[
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
    {
      "imagePath": "assets/png/book.png",
      "bookTitle": "Hamlet",
      "authorName": "William Shakespeare",
      "date": "18 june, 2026",
      "status": "Unsigned",
    },
  ].obs;

  void selectTab(String tab) {
    selectedTab.value = tab;
  }

  DateTime _parseDate(String dateStr) {
    try {
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
    List<Map<String, String>> books = List.from(libraryBooksList);

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
}
