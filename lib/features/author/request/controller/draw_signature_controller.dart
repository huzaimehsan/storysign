import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:storysign/constants/color_constants.dart';
import 'package:storysign/features/author/request/controller/place_signature_controller.dart';

import '../../../../core/services/request_service.dart';

class DrawSignatureController extends GetxController {
  SignatureController signatureController = SignatureController(
    penStrokeWidth: 4.0,
    penColor: blackColor,
    exportBackgroundColor: Colors.transparent,
  );

  // Mode can be 'pencil' or 'finger'
  final RxString signatureMode = 'pencil'.obs;
  final RxBool isSignatureEmpty = true.obs;
  final Rxn<Offset> fingerprintPosition = Rxn<Offset>();
  final RxBool isFingerprintPlaced = false.obs;
  final GlobalKey canvasKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    _registerListener();
  }

  void _registerListener() {
    signatureController.addListener(_onSignatureChange);
  }

  void _onSignatureChange() {
    isSignatureEmpty.value = signatureController.isEmpty;
  }

  void selectMode(String mode) {
    signatureMode.value = mode;
    final double width = (mode == 'pencil') ? 3.0 : 5.0;

    if (signatureController.penStrokeWidth == width) return;

    final currentPoints = signatureController.points;

    // Dispose old controller
    signatureController.removeListener(_onSignatureChange);
    signatureController.dispose();

    // Create new controller with existing points and new stroke width
    signatureController = SignatureController(
      penStrokeWidth: width,
      penColor: blackColor,
      exportBackgroundColor: Colors.transparent,
      points: currentPoints,
    );

    _registerListener();
    isSignatureEmpty.value = signatureController.isEmpty;
  }

  void undo() {
    signatureController.undo();
  }

  void redo() {
    signatureController.redo();
  }

  void clear() {
    signatureController.clear();
  }

  void placeFingerprint(Offset position) {
    fingerprintPosition.value = position;
    isFingerprintPlaced.value = true;
  }

  void resetFingerprint() {
    fingerprintPosition.value = null;
    isFingerprintPlaced.value = false;
  }

  Future<void> confirmSignature(BuildContext context, GlobalKey repaintKey) async {
    if (signatureMode.value == 'finger') {
      if (!isFingerprintPlaced.value) {
        Get.snackbar(
          'Fingerprint Required',
          'Please place your fingerprint first.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }

      final boundary = repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        Get.snackbar(
          'Export Error',
          'Unable to capture fingerprint canvas.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData?.buffer.asUint8List();

      if (bytes != null && context.mounted) {
        if (Get.isRegistered<PlaceSignatureController>()) {
          Get.delete<PlaceSignatureController>(force: true);
        }
        RequestService.find.signatureBytes = bytes;
        Navigator.of(context).pushNamed('/placeSignature', arguments: bytes);
      }
      return;
    }

    if (signatureController.isNotEmpty) {
      final bytes = await signatureController.toPngBytes();

      if (bytes != null && context.mounted) {
        if (Get.isRegistered<PlaceSignatureController>()) {
          Get.delete<PlaceSignatureController>(force: true);
        }
        RequestService.find.signatureBytes = bytes;

        Navigator.of(context).pushNamed('/placeSignature', arguments: bytes);
      }
    } else {
      Get.snackbar(
        'Empty Signature',
        'Please draw your signature before confirming.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    signatureController.removeListener(_onSignatureChange);
    signatureController.dispose();
    super.onClose();
  }
}
