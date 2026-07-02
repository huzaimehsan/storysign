import 'package:get/get.dart';

class HomeController extends GetxController {
  RxString selectedTab = "All".obs;

  RxInt selectedAuthorIndex = 0.obs;

  var authors = <Map<String, String>>[
    {"name": "James Davenport", "imagePath": "assets/png/authorimg.png"},
    {"name": "Jane Austen", "imagePath": "assets/png/authorimg.png"},
    {"name": "F. Scott Fitzgerald", "imagePath": "assets/png/authorimg.png"},
    {"name": "William Shakespeare", "imagePath": "assets/png/authorimg.png"},
    {"name": "Leo Tolstoy", "imagePath": "assets/png/authorimg.png"},
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
      "status": "Signed",
    },
    {
      "imagePath": "assets/png/book.png",
      "bookTitle": "The Great Gatsby",
      "authorName": "F. Scott Fitzgerald",
      "date": "25 june, 2026",
      "status": "Signed",
    },
  ].obs;

  RxString searchQuery = "".obs;

  List<Map<String, String>> get filteredAuthors {
    if (searchQuery.value.trim().isEmpty) {
      return authors;
    }
    final query = searchQuery.value.toLowerCase();
    return authors
        .where((author) =>
            author["name"]!.toLowerCase().contains(query))
        .toList();
  }

  List<Map<String, String>> get filteredRecentlySignedBooks {
    if (searchQuery.value.trim().isEmpty) {
      return recentlySignedBooksList;
    }
    final query = searchQuery.value.toLowerCase();
    return recentlySignedBooksList
        .where((book) =>
            book["bookTitle"]!.toLowerCase().contains(query) ||
            book["authorName"]!.toLowerCase().contains(query))
        .toList();
  }

  void selectAuthor(int index) {
    selectedAuthorIndex.value = index;
  }

  void selectTab(String tab) {
    selectedTab.value = tab;
  }
}