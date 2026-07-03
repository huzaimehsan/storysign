import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class EbookPreviewController extends GetxController {
  final PdfViewerController pdfViewerController = PdfViewerController();

  final RxInt currentPage = 1.obs;
  final RxInt pageCount = 0.obs;
  final RxDouble zoomLevel = 1.0.obs;
  final RxBool isLoading = true.obs;

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

  void signThisPage() {
    if (Get.context != null) {
      Navigator.of(Get.context!).pushNamed('/drawSignature');
    }
  }

  @override
  void onClose() {
    pdfViewerController.dispose();
    super.onClose();
  }
}
