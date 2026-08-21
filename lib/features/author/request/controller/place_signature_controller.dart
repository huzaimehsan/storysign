import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../../core/services/request_service.dart';

class PlaceSignatureController extends GetxController {
  Uint8List signatureBytes = Uint8List(0);

  final PdfViewerController pdfViewerController = PdfViewerController();
  String signatureMessage = '';
  String signatureDate = '';

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

  // @override
  // void onInit() {
  //   super.onInit();
  //   if (Get.arguments is Uint8List) {
  //     signatureBytes = Get.arguments as Uint8List;
  //   } else if (RequestService.find.signatureBytes != null) {
  //     signatureBytes = RequestService.find.signatureBytes!;
  //   }
  // }
  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is Map) {
      signatureBytes = (args['bytes'] as Uint8List?) ?? Uint8List(0);
      signatureMessage = (args['message'] as String?) ?? '';
      signatureDate = (args['date'] as String?) ?? '';
    } else if (args is Uint8List) {
      signatureBytes = args; // backward compatibility
    }

    // fallback agar service me already set ho (e.g. hot navigation)
    if (signatureBytes.isEmpty && RequestService.find.signatureBytes != null) {
      signatureBytes = RequestService.find.signatureBytes!;
    }
    if (signatureMessage.isEmpty) {
      signatureMessage = RequestService.find.signatureMessage;
    }
    if (signatureDate.isEmpty) {
      signatureDate = RequestService.find.signatureDate;
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
    xPosition.value = (xPosition.value + dx).clamp(
      0.0,
      constraints.maxWidth - sigWidth.value,
    );
    yPosition.value = (yPosition.value + dy).clamp(
      0.0,
      constraints.maxHeight - sigHeight.value,
    );
  }

  void updateSizeFromCorner(double dx, double dy) {
    sigWidth.value = (sigWidth.value + dx).clamp(100.0, 280.0);
    sigHeight.value = (sigHeight.value + dy).clamp(80.0, 140.0);
  }

  void rotateSignature() {
    rotationAngle.value =
        (rotationAngle.value + (30 * 3.141592653589793 / 180)) %
        (2 * 3.141592653589793);
  }

  double containerWidth = 300.0;
  double containerHeight = 400.0;

  int get scalePercentage => ((sigWidth.value / initialWidth) * 100).round();

  int get rotationDegrees =>
      ((rotationAngle.value * 180 / 3.141592653589793) % 360).round();

  Future<Uint8List> buildCompositeSignature() async {
    final double w = sigWidth.value;
    final double h = sigHeight.value;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, w, h));

    double yOffset = 0;

    // ── 1. Draw message text at top ──
    if (signatureMessage.isNotEmpty) {
      final tp = TextPainter(
        text: TextSpan(
          text: signatureMessage,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        maxLines: 2,
        ellipsis: '…',
      );
      tp.layout(maxWidth: w);
      tp.paint(canvas, Offset((w - tp.width) / 2, yOffset));
      yOffset += tp.height + 2;
    }

    // ── 2. Draw signature image ──
    final double dateHeight = signatureDate.isNotEmpty ? 14.0 : 0.0;
    final double sigAreaHeight = h - yOffset - dateHeight;

    if (signatureBytes.isNotEmpty) {
      final codec = await ui.instantiateImageCodec(signatureBytes);
      final frame = await codec.getNextFrame();
      final sigImg = frame.image;

      final srcRect = Rect.fromLTWH(
        0,
        0,
        sigImg.width.toDouble(),
        sigImg.height.toDouble(),
      );
      final dstRect = Rect.fromLTWH(0, yOffset, w, sigAreaHeight);
      canvas.drawImageRect(sigImg, srcRect, dstRect, Paint());
    }
    yOffset += sigAreaHeight;

    // ── 3. Draw date text at bottom ──
    if (signatureDate.isNotEmpty) {
      final tp = TextPainter(
        text: TextSpan(
          text: signatureDate,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 9,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      tp.layout(maxWidth: w);
      tp.paint(canvas, Offset((w - tp.width) / 2, yOffset));
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(w.toInt(), h.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void confirmPlacement(BuildContext context) async {
    double cW = containerWidth > 0 ? containerWidth : 300.0;
    double cH = containerHeight > 0 ? containerHeight : 400.0;

    final compositeBytes = await buildCompositeSignature();

    RequestService.find.setPlacementData(
      bytes: compositeBytes,
      pageIdx: (currentPage.value - 1).clamp(0, 99999),
      xR: double.parse(
        (xPosition.value / cW).clamp(0.0, 1.0).toStringAsFixed(4),
      ),
      yR: double.parse(
        (yPosition.value / cH).clamp(0.0, 1.0).toStringAsFixed(4),
      ),
      wR: double.parse(
        (sigWidth.value / cW).clamp(0.0, 1.0).toStringAsFixed(4),
      ),
      hR: double.parse(
        (sigHeight.value / cH).clamp(0.0, 1.0).toStringAsFixed(4),
      ),
      pW: 612.0,
      pH: 792.0,
    );

    Navigator.of(context).pushNamed('/authorFinalReview');
  }

  @override
  void onClose() {
    pdfViewerController.dispose();
    super.onClose();
  }
}
