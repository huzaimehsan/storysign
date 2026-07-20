

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
class UploadBookController extends GetxController {
  // 1. Declare variables at the class level
  final TextEditingController bookTitleController = TextEditingController();
  final Rxn<File> bookPdfFile = Rxn<File>();
  final Rxn<File> bookCoverImage = Rxn<File>();

  Future<void> uploadBook(BuildContext context) async {
    // 2. Access the controller text correctly
    final String title = bookTitleController.text.trim();

    // 3. Validation
    if (title.isEmpty) {
      Utils.showToast('Book title is required', true);
      return;
    }

    if (bookPdfFile.value == null || !bookPdfFile.value!.existsSync()) {
      Utils.showToast('PDF file is required', true);
      return;
    }

    if (bookCoverImage.value == null || !bookCoverImage.value!.existsSync()) {
      Utils.showToast('Cover image is required', true);
      return;
    }

    try {
      EasyLoading.show(status: 'Uploading book...', maskType: EasyLoadingMaskType.black);

      final uri = Uri.parse('${BaseService().baseURL}${ApiEndPoints.uploadBook}');
      final request = http.MultipartRequest('POST', uri);

      final token = SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN);
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields['title'] = title;

      // PDF file
      request.files.add(
        await http.MultipartFile.fromPath(
          'bookPdf',
          bookPdfFile.value!.path,
          contentType: MediaType('application', 'pdf'),
        ),
      );

      // Cover image
      request.files.add(
        await http.MultipartFile.fromPath(
          'coverImage',
          bookCoverImage.value!.path,
          contentType: MediaType('image', 'jpeg'), // Use generic or detect type
        ),
      );

      final streamedResponse = await request.send().timeout(const Duration(seconds: 60));
      final responseString = await streamedResponse.stream.bytesToString();
      final responseMap = json.decode(responseString);

      if (streamedResponse.statusCode >= 200 && streamedResponse.statusCode < 300) {
        Utils.showToast(responseMap['message'] ?? 'Book uploaded successfully', false);
        clearUploadBookFields();
        Get.back();
      } else {
        Utils.showToast(responseMap['message'] ?? 'Book upload failed', true);
      }
    } on TimeoutException {
      Utils.showToast('Request timed out', true);
    } catch (e) {
      Utils.showToast('Error: $e', true);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void clearUploadBookFields() {
    bookTitleController.clear();
    bookPdfFile.value = null;
    bookCoverImage.value = null;
  }
}