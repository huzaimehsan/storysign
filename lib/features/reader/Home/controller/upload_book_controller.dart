import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';

import '../../../../utils/utility.dart';
import '../../../../widgets/sucess_widget.dart';

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

      final fields = {
        'title': title,
      };

      final filePaths = {
        'bookPdf': bookPdfFile.value!.path,
        'coverImage': bookCoverImage.value!.path,
      };

      final responseMap = await BaseService().basePostMultipartAPI(
        ApiEndPoints.uploadBook,
        fields,
        filePaths: filePaths,
        loading: false,
      );

      if (responseMap['success'] == true) {
        clearUploadBookFields();
        showSuccessDialog(
          context,
          desc: responseMap['message'] ?? 'Book uploaded successfully',
          buttonText: 'Okay',
          ontap: () {
            Get.back();
            Get.back();
          },
        );
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
