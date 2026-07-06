import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/constants/color_constants.dart';
import 'package:storysign/widgets/customText_widget.dart';

/// Widget 2: "Ebook Detail" card — signature placement info + live signature preview
class SignatureDetailCard extends StatelessWidget {
  /// Reactive page number (e.g. from PlaceSignatureController.currentPage)
  final RxInt currentPage;

  /// Raw PNG bytes of the drawn signature (empty = show fallback squiggle)
  final Uint8List signatureBytes;

  const SignatureDetailCard({
    super.key,
    required this.currentPage,
    required this.signatureBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(5.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Left: text labels ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  text: 'Digital Signature',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: secondryColor,
                  letterSpacing: 0,
                  fontFamily: 'Poppins',
                ),
                SizedBox(height: 0.5.h),
                Obx(() => customText(
                      text:
                          'Placed on the page ${currentPage.value}. Center Right',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: primaryColor.withOpacity(0.7),
                      fontFamily: 'Poppins',
                    )),
              ],
            ),
          ),

          // ── Right: signature preview ──
          Container(
            height: 10.h,
            width: 25.w,
            alignment: Alignment.center,
            child: signatureBytes.isEmpty
                ? CustomPaint(
                    size: Size(20.w, 6.h),
                    painter: _SquigglePainter(),
                  )
                : Image.memory(
                    signatureBytes,
                    fit: BoxFit.contain,
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Fallback squiggle painter ──
class _SquigglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final cx = size.width * 0.1;
    final cy = size.height * 0.5;
    path.moveTo(cx, cy);
    path.cubicTo(cx + 10, cy - 12, cx + 20, cy + 12, cx + 30, cy);
    path.cubicTo(cx + 40, cy - 12, cx + 50, cy + 12, cx + 60, cy);
    path.cubicTo(cx + 70, cy - 12, cx + 80, cy + 12, cx + 90, cy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
