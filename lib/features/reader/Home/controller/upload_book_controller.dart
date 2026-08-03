import 'package:get/get.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';

class UploadBookController extends GetxController {
  final TextEditingController bookTitleController = TextEditingController();
  final Rxn<File> bookPdfFile = Rxn<File>();
  final Rxn<File> bookCoverImage = Rxn<File>();

  Future<void> uploadBook(BuildContext context) async {
    final String title = bookTitleController.text.trim();

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
      EasyLoading.show(
        status: 'Uploading book...',
        maskType: EasyLoadingMaskType.black,
      );

      final uri = Uri.parse(
        '${BaseService().baseURL}${ApiEndPoints.uploadBook}',
      );
      final request = http.MultipartRequest('POST', uri);

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
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      final responseMap = await BaseService().baseMultipartPostAPI(
        ApiEndPoints.uploadBook,
        request: request,
        loading: false,
      );

      if (responseMap['success'] == true) {
        Utils.showToast(
          responseMap['message'] ?? 'Book uploaded successfully',
          false,
        );
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
