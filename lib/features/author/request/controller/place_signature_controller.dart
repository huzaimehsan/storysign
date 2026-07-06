import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PlaceSignatureController extends GetxController {
  Uint8List signatureBytes = Uint8List(0);

  final PdfViewerController pdfViewerController = PdfViewerController();


  final RxDouble xPosition = 40.0.obs;
  final RxDouble yPosition = 160.0.obs;

  // Signature overlay size
  final RxDouble sigWidth = 140.0.obs;
  final RxDouble sigHeight = 65.0.obs;

  // Rotation in radians
  final RxDouble rotationAngle = 0.0.obs;

  final RxInt currentPage = 1.obs;
  final RxInt pageCount = 0.obs;
  final RxBool isLoading = true.obs;

  final double initialWidth = 140.0;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Uint8List) {
      signatureBytes = Get.arguments as Uint8List;
    }
  }

  void onDocumentLoaded(PdfDocumentLoadedDetails details) {
    pageCount.value = pdfViewerController.pageCount;
    isLoading.value = false;
  }

  void onPageChanged(PdfPageChangedDetails details) {
    currentPage.value = details.newPageNumber;
  }

  void nextPage() => pdfViewerController.nextPage();
  void previousPage() => pdfViewerController.previousPage();

  void updatePosition(double dx, double dy, BoxConstraints constraints) {
    xPosition.value = (xPosition.value + dx)
        .clamp(0.0, constraints.maxWidth - sigWidth.value);
    yPosition.value = (yPosition.value + dy)
        .clamp(0.0, constraints.maxHeight - sigHeight.value);
  }

  void updateSizeFromCorner(double dx, double dy) {
    sigWidth.value = (sigWidth.value + dx).clamp(60.0, 280.0);
    sigHeight.value = (sigHeight.value + dy).clamp(30.0, 140.0);
  }

  void rotateSignature() {
    rotationAngle.value =
        (rotationAngle.value + (30 * 3.141592653589793 / 180)) %
            (2 * 3.141592653589793);
  }

  int get scalePercentage =>
      ((sigWidth.value / initialWidth) * 100).round();

  int get rotationDegrees =>
      ((rotationAngle.value * 180 / 3.141592653589793) % 360).round();

  void confirmPlacement(BuildContext context) {
    Navigator.of(context).pushNamed('/addMessage');
  }

  @override
  void onClose() {
    pdfViewerController.dispose();
    super.onClose();
  }
}
