import 'dart:async';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../core/services/request_service.dart';
import '../../../../utils/utility.dart';

class EbookPreviewController extends GetxController {
  final PdfViewerController pdfViewerController = PdfViewerController();

  final RxInt currentPage = 1.obs;
  final RxInt pageCount = 0.obs;
  final RxDouble zoomLevel = 1.0.obs;
  final RxBool isLoading = true.obs;
  final BaseService baseService = BaseService();
  final RxString bookPdfUrl = ''.obs;
  String autographRequestId = '';
  bool _isInitialized = false;

  void initWithId(String id, {String bookPdf = '', bool shouldAccept = false}) {
    if (autographRequestId != id) {
      bookPdfUrl.value = '';
      isLoading.value = false;
      _isInitialized = false;
    }

    final alreadyAccepted = RequestService.find.acceptedRequestIds.contains(id);

    if (_isInitialized && autographRequestId == id) {
      if (alreadyAccepted && bookPdfUrl.value.isNotEmpty) {
        return;
      }
    }
    _isInitialized = true;

    autographRequestId = id;
    print(
      '📌 EbookPreviewController - ID received: $autographRequestId, bookPdf passed: ${bookPdf.isNotEmpty}, shouldAccept: $shouldAccept, alreadyAccepted: $alreadyAccepted',
    );

    if (bookPdf.isNotEmpty) {
      bookPdfUrl.value = bookPdf;
      isLoading.value = true;
      if (alreadyAccepted || shouldAccept) {
        RequestService.find.markRequestAccepted(id);
        return;
      }
      RequestService.find.markRequestAccepted(id);
      if (autographRequestId.isNotEmpty) {
        acceptRequestAndLoadPdf(skipPdfUpdate: true);
      }
      return;
    }

    if (autographRequestId.isNotEmpty) {
      if (alreadyAccepted) {
        final savedPdf = RequestService.find.bookPdfUrl;
        if (savedPdf.isNotEmpty) {
          bookPdfUrl.value = savedPdf;
          isLoading.value = false;
          return;
        }
      }

      if (!shouldAccept && alreadyAccepted) {
        return;
      }

      acceptRequestAndLoadPdf();
    } else {
      Utils.showToast('Request ID missing', true);
    }
  }

  Future<void> acceptRequestAndLoadPdf({bool skipPdfUpdate = false}) async {
    try {
      final response = await baseService.basePostAPI(
        ApiEndPoints.acceptAutographRequest(autographRequestId),
        {},
        loading: !skipPdfUpdate,
        showErrorToast: !skipPdfUpdate,
      );

      print('✅ ACCEPT RESPONSE: $response');
      print('✅ ALL KEYS IN RESPONSE: ${response.keys.toList()}');

      if (response['success'] == true) {
        RequestService.find.markRequestAccepted(autographRequestId);

        if (skipPdfUpdate) {
          // Accept succeeded but we already have the PDF — nothing more to do
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
        RequestService.find.bookPdfUrl = pdfUrl.toString();
        isLoading.value = true;
      } else {
        final message = response['message']?.toString() ?? '';
        final statusCode = response['statusCode'];
        final isAlreadyAccepted = statusCode == 400 ||
            statusCode == 404 ||
            message.toLowerCase().contains('not found') ||
            message.toLowerCase().contains('already');

        if (isAlreadyAccepted) {
          RequestService.find.markRequestAccepted(autographRequestId);
          final savedPdf = RequestService.find.bookPdfUrl;
          if (savedPdf.isNotEmpty) {
            bookPdfUrl.value = savedPdf;
            isLoading.value = false;
          }
          if (skipPdfUpdate) {
            print('Silently ignored repeated accept call: $message');
          }
          return;
        }

        if (skipPdfUpdate) {
          // Already have PDF — silently ignore accept failure
          print('Silently ignored accept failure: $message');
        }
        // When !skipPdfUpdate, basePostAPI already showed the error toast
      }
    } catch (e) {
      if (skipPdfUpdate) {
        print('Silently ignored accept failure: $e');
      } else {
        Utils.showToast('Something went wrong: $e', true);
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