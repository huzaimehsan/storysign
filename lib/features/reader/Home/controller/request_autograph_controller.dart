

import 'package:get/get.dart';

import 'package:get/get.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';
import '../model/home_model.dart';
class RequestAutographController extends GetxController{
  var receivedBookId = ''.obs; //
  final TextEditingController bookTitleController = TextEditingController();
  final TextEditingController bookTitleControllerRequest =
  TextEditingController();
  final TextEditingController personalMessageController =
  TextEditingController();
  RxString selectedAuthorId = "".obs;
  RxList<BookItem> trackRequest = <BookItem>[].obs;
  final Rxn<File> bookPdfFile = Rxn<File>();
  final Rxn<File> bookCoverImage = Rxn<File>();
// Controller mein
  // Return type ko String? se Map<String, dynamic>? mein badla hai
  Future<Map<String, dynamic>?> requestAutograph(
      BuildContext context,
      String authorId, {
        String? bookId,
      }) async {
    bool isLibrary = bookId != null && bookId.isNotEmpty;

    // ... (Validation logic wahi rahega) ...

    try {
      EasyLoading.show(status: 'Sending...', maskType: EasyLoadingMaskType.black);

      final uri = Uri.parse('${BaseService().baseURL}${ApiEndPoints.requestAutoGraphHome}');
      final request = http.MultipartRequest('POST', uri);

      final token = SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['authorId'] = authorId;
      request.fields['personalMessage'] = personalMessageController.text.trim();

      if (isLibrary) {
        request.fields['bookId'] = bookId!;
      } else {
        request.fields['bookTitle'] = bookTitleControllerRequest.text.trim();
        request.files.add(await http.MultipartFile.fromPath('bookPdf', bookPdfFile.value!.path));
        request.files.add(await http.MultipartFile.fromPath('coverImage', bookCoverImage.value!.path));
      }

      final streamedResponse = await request.send();
      final responseString = await streamedResponse.stream.bytesToString();
      final responseMap = json.decode(responseString);

      debugPrint("API Response: $responseMap"); // Debug ke liye

      if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201) {
        clearRequestBookFields();

        // 'request' object ko alag extract karein
        final requestData = responseMap['request'];

        // Root level se payment details extract karein
        return {
          'requestId': requestData['id']?.toString(),
          'paymentIntentId': responseMap['paymentIntentId']?.toString(), // Root se
          'clientSecret': responseMap['clientSecret']?.toString(),       // Root se
        };
      }

      Utils.showToast(responseMap['message'] ?? 'Request failed', true);
      return null;
    } catch (e) {
      Utils.showToast('Error: $e', true);
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }

  void clearRequestBookFields() {
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