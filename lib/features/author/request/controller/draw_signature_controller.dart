import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:storysign/constants/color_constants.dart';

class DrawSignatureController extends GetxController {
  final SignatureController signatureController = SignatureController(
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
    signatureController.addListener(() {
      isSignatureEmpty.value = signatureController.isEmpty;
    });
  }

  void selectMode(String mode) {
    signatureMode.value = mode;
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

  void confirmSignature() {
    // Process signature (e.g. export to PNG image)
    if (signatureController.isNotEmpty) {
      Get.back();
      // Add logic to save or send the signature image
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
    signatureController.dispose();
    super.onClose();
  }
}
