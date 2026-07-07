import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  RxString selectedTab = "All".obs;

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
      "imagePath": "assets/png/authorimg.png",
      "date": "Joined: 22 june, 2026",
      "active": true,
    },
    {
      "name": "F. Scott Fitzgerald",
      "imagePath": "assets/png/authorimg.png",
      "date": "Joined: 22 june, 2026",
      "active": true,
    },
    {
      "name": "William Shakespeare",
      "imagePath": "assets/png/authorimg.png",
      "date": "Joined: 22 june, 2026",
      "active": false,
    },
    {
      "name": "Leo Tolstoy",
      "imagePath": "assets/png/authorimg.png",
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
}