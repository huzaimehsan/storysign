import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthorHomeController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  final RxList<Map<String, String>> requests = <Map<String, String>>[
    {
      'imagePath': 'assets/png/pendingimg.png',
      'authorName': 'Jane Austen',
      'date': '22 june, 2026',
      'bookName': 'The Origin of Species',
    },
    {
      'imagePath': 'assets/png/searchprofile.png',
      'authorName': 'Emily Bronte',
      'date': '24 june, 2026',
      'bookName': 'Wuthering Heights',
    },
    {
      'imagePath': 'assets/png/searchprofile.png',
      'authorName': 'George Orwell',
      'date': '26 june, 2026',
      'bookName': '1984',
    },
    {
      'imagePath': 'assets/png/searchprofile.png',
      'authorName': 'Mark Twain',
      'date': '28 june, 2026',
      'bookName': 'Adventures of Tom Sawyer',
    },
  ].obs;

  final RxList<Map<String, String>> filteredRequests = <Map<String, String>>[].obs;

  @override
  void onInit() {
    filteredRequests.assignAll(requests);
    super.onInit();
  }

  void filterRequests(String query) {
    final lowerQuery = query.toLowerCase().trim();

    if (lowerQuery.isEmpty) {
      filteredRequests.assignAll(requests);
      return;
    }

    filteredRequests.assignAll(
      requests.where((request) {
        final authorName = request['authorName']?.toLowerCase() ?? '';
        final bookName = request['bookName']?.toLowerCase() ?? '';
        return authorName.contains(lowerQuery) || bookName.contains(lowerQuery);
      }).toList(),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
