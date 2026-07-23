import 'package:flutter/material.dart';
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

  void confirmSignature(BuildContext context) async {
    // Process signature (export to PNG image bytes)
    if (signatureController.isNotEmpty) {
      final bytes = await signatureController.toPngBytes();
      // Guard context use after async gap
      if (bytes != null && context.mounted) {
        // Delete old controller if registered so it is recreated fresh by the route's GetPageRoute binding
        if (Get.isRegistered<PlaceSignatureController>()) {
          Get.delete<PlaceSignatureController>(force: true);
        }
        RequestService.find.signatureBytes = bytes;
        // Use screen's context so we push through the NESTED navigator (tab 1)
        // This keeps the parent scaffold's bottom nav visible
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
