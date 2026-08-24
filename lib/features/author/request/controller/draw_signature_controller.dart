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

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController messageController = TextEditingController();
  final RxInt charCount = 0.obs;
  final TextEditingController dateController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _registerListener();
    messageController.addListener(() {
      charCount.value = messageController.text.length;
    });
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: buttonColor, // Selected dates and header
              onPrimary: white, // Text on primary
              onSurface: blackColor, // General text
              surface: white, // Dialog background
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: white,
              headerBackgroundColor: buttonColor,
              headerForegroundColor: white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              dayStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
              weekdayStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              yearStyle: const TextStyle(fontFamily: 'Poppins'),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: buttonColor, // Button text color
                textStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dateController.text = "${picked.toLocal()}".split(' ')[0];
    }
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
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (signatureController.isNotEmpty) {
      // Scale factor to increase the resolution of the exported PNG
      final double scale = 4.0; 
      
      final List<Point> scaledPoints = signatureController.points.map((p) {
        return Point(
          Offset(p.offset.dx * scale, p.offset.dy * scale),
          p.type,
          p.pressure,
        );
      }).toList();

      final highResController = SignatureController(
        penStrokeWidth: signatureController.penStrokeWidth * scale,
        penColor: signatureController.penColor,
        exportBackgroundColor: signatureController.exportBackgroundColor,
        points: scaledPoints,
      );

      final bytes = await highResController.toPngBytes();
      highResController.dispose();

      if (bytes != null && context.mounted) {
        if (Get.isRegistered<PlaceSignatureController>()) {
          Get.delete<PlaceSignatureController>(force: true);
        }
        RequestService.find.signatureBytes = bytes;
        RequestService.find.signatureMessage = messageController.text;
        RequestService.find.signatureDate = dateController.text;

        Navigator.of(context).pushNamed(
          '/placeSignature',
          arguments: {
            'bytes': bytes,
            'message': messageController.text,
            'date': dateController.text,
          },
        );
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
    messageController.dispose();
    dateController.dispose();
    super.onClose();
  }
}
