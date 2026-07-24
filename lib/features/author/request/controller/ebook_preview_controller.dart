import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';

class EbookPreviewController extends GetxController {
  final PdfViewerController pdfViewerController = PdfViewerController();

  final RxInt currentPage = 1.obs;
  final RxInt pageCount = 0.obs;
  final RxDouble zoomLevel = 1.0.obs;
  final RxBool isLoading = true.obs; // PDF viewer ka loading (pehle se hai)

  // Naya state: API se request fetch ho rahi hai ya nahi
  final RxBool isFetching = true.obs;
  final RxString bookPdfUrl = ''.obs;
  final RxString errorMessage = ''.obs;
  late String autographRequestId;

  @override
  void onInit() {
    super.onInit();
    // ID ab View se initWithId() ke zariye milegi (ModalRoute pattern)
  }

  void initWithId(String id, {String bookPdf = ''}) {
    autographRequestId = id;
    print('📌 EbookPreviewController - ID received: $autographRequestId, bookPdf passed: ${bookPdf.isNotEmpty}');

    if (bookPdf.isNotEmpty) {
      bookPdfUrl.value = bookPdf;
      isLoading.value = true;
      return;
    }

    if (autographRequestId.isNotEmpty) {
      acceptRequestAndLoadPdf();
    } else {
      Utils.showToast('Request ID missing', true);
    }
  }

  Future<void> acceptRequestAndLoadPdf() async {
    if (autographRequestId.isEmpty) {
      Utils.showToast('Request ID missing', true);
      return;
    }

    try {
      EasyLoading.show(
        status: 'Loading PDF...',
        maskType: EasyLoadingMaskType.black,
      );

      final uri = Uri.parse(
        '${BaseService().baseURL}${ApiEndPoints.acceptAutographRequest(autographRequestId)}',
      );

      final token = SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN);

      final response = await http.post(
        uri,
        headers: {
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      final responseMap = json.decode(response.body);

      print('✅ ACCEPT RESPONSE STATUS: ${response.statusCode}');
      print('✅ ACCEPT FULL RESPONSE: $responseMap');
      print('✅ ALL KEYS IN RESPONSE: ${responseMap.keys.toList()}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ Multiple possible keys check karo
        final pdfUrl = responseMap['bookUrl']
            ?? responseMap['pdfUrl']
            ?? responseMap['bookPdfUrl']
            ?? responseMap['pdf']
            ?? responseMap['url']
            ?? responseMap['fileUrl']
            ?? responseMap['documentUrl'];

        print('📄 PDF URL found: $pdfUrl');

        if (pdfUrl == null || pdfUrl.toString().isEmpty) {
          Utils.showToast('PDF url not found in response', true);
          print('❌ Available keys: ${responseMap.keys.toList()}');
          print('❌ Full response: $responseMap');
          return;
        }

        bookPdfUrl.value = pdfUrl.toString();
        isLoading.value = true;
      } else {
        Utils.showToast(responseMap['message'] ?? 'Request failed', true);
      }
    } on TimeoutException {
      Utils.showToast('Request timed out', true);
    } catch (e) {
      Utils.showToast('Something went wrong: $e', true);
    } finally {
      EasyLoading.dismiss();
    }
  }
  void onDocumentLoaded(PdfDocumentLoadedDetails details) {
    pageCount.value = pdfViewerController.pageCount;
    isLoading.value = false;
  }

  void onPageChanged(PdfPageChangedDetails details) {
    currentPage.value = details.newPageNumber;
  }

  void onZoomLevelChanged(PdfZoomDetails details) {
    zoomLevel.value = details.newZoomLevel;
  }

  void zoomIn() {
    zoomLevel.value = (zoomLevel.value + 0.25).clamp(1.0, 3.0);
    pdfViewerController.zoomLevel = zoomLevel.value;
  }

  void zoomOut() {
    zoomLevel.value = (zoomLevel.value - 0.25).clamp(1.0, 3.0);
    pdfViewerController.zoomLevel = zoomLevel.value;
  }

  void nextPage() {
    pdfViewerController.nextPage();
  }

  void previousPage() {
    pdfViewerController.previousPage();
  }

  @override
  void onClose() {
    pdfViewerController.dispose();
    super.onClose();
  }
}