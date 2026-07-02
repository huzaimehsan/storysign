import 'package:get/get.dart';

class HelpAndSupportController extends GetxController {
  // Original data
  final List<Map<String, String>> allFaqs = [
    {'title': '1. What is StorySign?', 'description': 'StorySign is a digital platform...'},
    {'title': '2. How does StorySign work?', 'description': 'Readers can browse author profiles...'},
    {'title': '3. Can readers upload their own ebooks?', 'description': 'Yes. Readers can upload...'},
    {'title': '4. Do authors need a subscription plan?', 'description': 'Yes. Authors must subscribe...'},
    {'title': '5. What subscription plans are available?', 'description': 'Starter Plan – 25 signatures...'},
    {'title': '6. Can authors reject signature requests?', 'description': 'Yes. Authors can either...'},
    {'title': '7. What payment methods are supported?', 'description': 'StorySign supports secure...'},
  ];

  // Search query state
  var searchQuery = ''.obs;


  List<Map<String, String>> get filteredFaqs {
    if (searchQuery.value.isEmpty) {
      return allFaqs;
    } else {
      return allFaqs.where((faq) =>
      faq['title']!.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          faq['description']!.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }
  }
}