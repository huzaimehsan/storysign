import 'dart:async';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/utility.dart';

class EbookPreviewController extends GetxController {
  final PdfViewerController pdfViewerController = PdfViewerController();

  final RxInt currentPage = 1.obs;
  final RxInt pageCount = 0.obs;
  final RxDouble zoomLevel = 1.0.obs;
  final RxBool isLoading = true.obs;
  final BaseService baseService = BaseService();
  final RxString bookPdfUrl = ''.obs;
  late String autographRequestId;
  bool _isInitialized = false;

  void initWithId(String id, {String bookPdf = '', bool shouldAccept = false}) {
    if (_isInitialized) return;
    _isInitialized = true;

    autographRequestId = id;
    print(
      '📌 EbookPreviewController - ID received: $autographRequestId, bookPdf passed: ${bookPdf.isNotEmpty}, shouldAccept: $shouldAccept',
    );

    if (bookPdf.isNotEmpty) {
      bookPdfUrl.value = bookPdf;
      isLoading.value = true;

      if (shouldAccept && autographRequestId.isNotEmpty) {
        acceptRequestAndLoadPdf(skipPdfUpdate: true);
      }
      return;
    }

    if (autographRequestId.isNotEmpty) {
      acceptRequestAndLoadPdf();
    } else {
      Utils.showToast('Request ID missing', true);
    }
  }

  Future<void> acceptRequestAndLoadPdf({bool skipPdfUpdate = false}) async {
    // if (autographRequestId.isEmpty) {
    //   Utils.showToast('Request ID missing', true);
    //   return;
    // }

    try {
      final response = await baseService.basePostAPI(
        ApiEndPoints.acceptAutographRequest(autographRequestId),
        {},
        loading: true,
        showErrorToast: skipPdfUpdate,
      );

      print('✅ ACCEPT RESPONSE: $response');
      print('✅ ALL KEYS IN RESPONSE: ${response.keys.toList()}');

      if (response['success'] == true) {
        if (skipPdfUpdate) {
          return;
        }

        // Multiple possible keys check
        final pdfUrl = response['bookUrl'] ??
            response['pdfUrl'] ??
            response['bookPdfUrl'] ??
            response['pdf'] ??
            response['url'] ??
            response['fileUrl'] ??
            response['documentUrl'];

        print('📄 PDF URL found: $pdfUrl');

        if (pdfUrl == null || pdfUrl.toString().isEmpty) {
          Utils.showToast('PDF url not found in response', true);
          print('❌ Available keys: ${response.keys.toList()}');
          print('❌ Full response: $response');
          return;
        }

        bookPdfUrl.value = pdfUrl.toString();
        isLoading.value = true;
      } else {
        final message = response['message'];
        final statusCode = response['statusCode'];

        if (skipPdfUpdate &&
            (message == 'Request not found' ||
                statusCode == 404 ||
                statusCode == 400)) {
          // baseService already error toast dikha chuka hoga (error path me),
          // agar skipPdfUpdate hai to bas silently ignore/log karo
          print('Silently ignored accept failure: $message');
        }
        // else: baseService.basePostAPI ne already error toast show kar diya hai,
        // isliye yahan dobara toast nahi maar rahe (duplicate avoid karne ke liye)
      }
    } catch (e) {
      if (!skipPdfUpdate) {
        Utils.showToast('Something went wrong: $e', true);
      } else {
        print('Silently ignored accept failure: $e');
      }
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