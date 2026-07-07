import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveredController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  final RxList<Map<String, String>> requests = <Map<String, String>>[
    {
      'imagePath': 'assets/png/searchprofile.png',
      'authorName': 'Jane Austen',
      'bookName': 'The Origin of Species',
      'date' : '22 june,2026'
    },
    {
      'imagePath': 'assets/png/searchprofile.png',
      'authorName': 'Emily Bronte',
      'bookName': 'Wuthering Heights',
      'date' : '22 june,2026',
    },
    {
      'imagePath': 'assets/png/searchprofile.png',
      'authorName': 'George Orwell',
      'bookName': '1984',
      'date' : '22 june,2026',
    },
    {
      'imagePath': 'assets/png/searchprofile.png',
      'authorName': 'Mark Twain',
      'bookName': 'Adventures of Tom Sawyer',
      'date' : '22 june,2026',
    },
    {
      'imagePath': 'assets/png/searchprofile.png',
      'authorName': 'F. Scott Fitzgerald',
      'bookName': 'The Great Gatsby',
      'date' : '22 june,2026'
    },

    {
      'imagePath': 'assets/png/searchprofile.png',
      'authorName': 'F. Scott Fitzgerald',
      'bookName': 'The Great Gatsby',
      'date' : '22 june,2026'
    },

    {
      'imagePath': 'assets/png/searchprofile.png',
      'authorName': 'F. Scott Fitzgerald',
      'bookName': 'The Great Gatsby',
      'date' : '22 june,2026'
    },

    {
      'imagePath': 'assets/png/searchprofile.png',
      'authorName': 'F. Scott Fitzgerald',
      'bookName': 'The Great Gatsby',
      'date' : '22 june,2026'
    },

    {
      'imagePath': 'assets/png/searchprofile.png',
      'authorName': 'F. Scott Fitzgerald',
      'bookName': 'The Great Gatsby',
      'date' : '22 june,2026'
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
