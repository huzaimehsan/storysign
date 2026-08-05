import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/utility.dart';
import '../model/home_model.dart';

class RequestAutographController extends GetxController {
  var receivedBookId = ''.obs; //
  final TextEditingController bookTitleController = TextEditingController();
  final TextEditingController bookTitleControllerRequest =
      TextEditingController();
  final TextEditingController personalMessageController =
      TextEditingController();
  RxString selectedAuthorId = "".obs;
  RxString selectedAuthorName = "".obs;
  RxList<NewBookItem> trackRequest = <NewBookItem>[].obs;
  final Rxn<File> bookPdfFile = Rxn<File>();
  final Rxn<File> bookCoverImage = Rxn<File>();
  // Controller mein
  // Return type ko String? se Map<String, dynamic>? mein badla hai
  // Future<Map<String, dynamic>?> requestAutograph(
  //     BuildContext context,
  //     String authorId, {
  //       String? bookId,
  //     }) async {
  //   bool isLibrary = bookId != null && bookId.isNotEmpty;
  //
  //   // ... (Validation logic wahi rahega) ...
  //
  //   try {
  //     EasyLoading.show(status: 'Sending...', maskType: EasyLoadingMaskType.black);
  //
  //     final uri = Uri.parse('${BaseService().baseURL}${ApiEndPoints.requestAutoGraphHome}');
  //     final request = http.MultipartRequest('POST', uri);
  //
  //     final token = SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN);
  //     request.headers['Authorization'] = 'Bearer $token';
  //
  //     request.fields['authorId'] = authorId;
  //     request.fields['personalMessage'] = personalMessageController.text.trim();
  //
  //     if (isLibrary) {
  //       request.fields['bookId'] = bookId!;
  //     } else {
  //       request.fields['bookTitle'] = bookTitleControllerRequest.text.trim();
  //       request.files.add(await http.MultipartFile.fromPath('bookPdf', bookPdfFile.value!.path));
  //       request.files.add(await http.MultipartFile.fromPath('coverImage', bookCoverImage.value!.path));
  //     }
  //
  //     final streamedResponse = await request.send();
  //     final responseString = await streamedResponse.stream.bytesToString();
  //     final responseMap = json.decode(responseString);
  //
  //     debugPrint("API Response: $responseMap"); // Debug ke liye
  //
  //     if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201) {
  //       clearRequestBookFields();
  //
  //       // 'request' object ko alag extract karein
  //       final requestData = responseMap['request'];
  //
  //       // Root level se payment details extract karein
  //       return {
  //         'requestId': requestData['id']?.toString(),
  //         'paymentIntentId': responseMap['paymentIntentId']?.toString(), // Root se
  //         'clientSecret': responseMap['clientSecret']?.toString(),       // Root se
  //       };
  //     }
  //
  //     Utils.showToast(responseMap['message'] ?? 'Request failed', true);
  //     return null;
  //   } catch (e) {
  //     Utils.showToast('Error: $e', true);
  //     return null;
  //   } finally {
  //     EasyLoading.dismiss();
  //   }
  // }
  Future<Map<String, dynamic>?> requestAutograph(
    BuildContext context,
    String authorId, {
    String? bookId,
  }) async {
    bool isLibrary = bookId != null && bookId.isNotEmpty;

    // ... (Validation logic wahi rahega) ...

    try {
      Map<String, dynamic> response;

      if (isLibrary) {
        response = await BaseService()
            .basePostAPI(ApiEndPoints.requestAutoGraphHome, {
              'authorId': authorId,
              'personalMessage': personalMessageController.text.trim(),
              'bookId': bookId!,
            });
      } else {
        final filePaths = {
          'bookPdf': bookPdfFile.value!.path,
          'coverImage': bookCoverImage.value!.path,
        };

        response = await BaseService().basePostMultipartAPI(
          ApiEndPoints.requestAutoGraphHome,
          {
            'authorId': authorId,
            'personalMessage': personalMessageController.text.trim(),
            'bookTitle': bookTitleControllerRequest.text.trim(),
          },
          filePaths: filePaths,
        );
      }

      debugPrint("API Response: $response");

      if (response['success'] == true) {
        clearRequestBookFields();

        final requestData = response['request'];

        return {
          'requestId': requestData?['id']?.toString(),
          'paymentIntentId': response['paymentIntentId']?.toString(),
          'clientSecret': response['clientSecret']?.toString(),
        };
      }

      return null;
    } catch (e) {
      debugPrint('requestAutograph error: $e');
      Utils.showToast('Error: $e', true);
      return null;
    }
  }

  void clearRequestBookFields() {
    bookTitleControllerRequest.clear();
    personalMessageController.clear();
    bookPdfFile.value = null;
    bookCoverImage.value = null;
  }

  void resetRequestForm() {
    selectedAuthorId.value = '';
    selectedAuthorName.value = '';
    receivedBookId.value = '';
    bookTitleControllerRequest.clear();
    personalMessageController.clear();
    bookPdfFile.value = null;
    bookCoverImage.value = null;
  }

  @override
  void onClose() {
    bookTitleController.dispose();
    bookTitleControllerRequest.dispose();
    personalMessageController.dispose();
    super.onClose();
  }
}
