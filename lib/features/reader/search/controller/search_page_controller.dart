import 'package:get/get.dart';

class SearchPageController extends GetxController {
  var authors = <Map<String, String>>[
    {
      "imagePath": "assets/png/searchprofile.png",
      "bookTitle": "Matt Haig",
      "date": "Joined: 22 june, 2026",
    },
    {
      "imagePath": "assets/png/searchprofile.png",
      "bookTitle": "James Davenport",
      "date": "Joined: 15 june, 2026",
    },
    {
      "imagePath": "assets/png/searchprofile.png",
      "bookTitle": "Jane Austen",
      "date": "Joined: 18 june, 2026",
    },
    {
      "imagePath": "assets/png/searchprofile.png",
      "bookTitle": "F. Scott Fitzgerald",
      "date": "Joined: 20 june, 2026",
    },
    {
      "imagePath": "assets/png/searchprofile.png",
      "bookTitle": "Jane Austen",
      "date": "Joined: 18 june, 2026",
    },
    {
      "imagePath": "assets/png/searchprofile.png",
      "bookTitle": "Jane Austen",
      "date": "Joined: 18 june, 2026",
    },
    {
      "imagePath": "assets/png/searchprofile.png",
      "bookTitle": "Jane Austen",
      "date": "Joined: 18 june, 2026",
    },
    {
      "imagePath": "assets/png/searchprofile.png",
      "bookTitle": "William Shakespeare",
      "date": "Joined: 10 june, 2026",
    },
  ].obs;

  RxString searchQuery = "".obs;

  List<Map<String, String>> get filteredAuthors {
    if (searchQuery.value.trim().isEmpty) {
      return authors;
    }
    final query = searchQuery.value.toLowerCase();
    return authors
        .where((author) => author["bookTitle"]!.toLowerCase().contains(query))
        .toList();
  }
}
