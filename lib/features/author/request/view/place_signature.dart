import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/constants/color_constants.dart';
import 'package:storysign/widgets/button_widget.dart';
import 'package:storysign/widgets/customText_widget.dart';
import 'package:storysign/widgets/subscription_header_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../core/services/request_service.dart';
import '../controller/place_signature_controller.dart';

class PlaceSignatureScreen extends GetView<PlaceSignatureController> {
  const PlaceSignatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ──────────── Header ────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: customHeaderAuthor(
                context: context,
                title: 'Place Signature',
                onBack: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    Get.back();
                  }
                },
                onIconPressed: () {},
              ),
            ),

            SizedBox(height: 3.h),

            // ──────────── PDF + Signature Overlay Container ────────────
            Container(
              height: 48.h,
              width: 90.w,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(5.w),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(80),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.w),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    controller.containerWidth = constraints.maxWidth;
                    controller.containerHeight = constraints.maxHeight;

                    final pdfUrl = RequestService.find.bookPdfUrl;

                    return Stack(
                      children: [
                        // ── Real PDF viewer ──
                        pdfUrl.isNotEmpty
                            ? SfPdfViewer.network(
                                pdfUrl,
                                controller: controller.pdfViewerController,
                                pageLayoutMode: PdfPageLayoutMode.single,
                                scrollDirection: PdfScrollDirection.horizontal,
                                onDocumentLoaded: controller.onDocumentLoaded,
                                onPageChanged: controller.onPageChanged,
                                canShowScrollHead: false,
                                canShowScrollStatus: false,
                                canShowPaginationDialog: false,
                              )
                            : SfPdfViewer.asset(
                                'assets/book/pdf.pdf',
                                controller: controller.pdfViewerController,
                                pageLayoutMode: PdfPageLayoutMode.single,
                                scrollDirection: PdfScrollDirection.horizontal,
                                onDocumentLoaded: controller.onDocumentLoaded,
                                onPageChanged: controller.onPageChanged,
                                canShowScrollHead: false,
                                canShowScrollStatus: false,
                                canShowPaginationDialog: false,
                              ),

                        // ── Loading spinner ──
                        Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  buttonColor,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),

                        // ── Draggable & resizable signature overlay ──
                        Obx(() {
                          return Positioned(
                            left: controller.xPosition.value,
                            top: controller.yPosition.value,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                controller.updatePosition(
                                  details.delta.dx,
                                  details.delta.dy,
                                  constraints,
                                );
                              },
                              child: Transform.rotate(
                                angle: controller.rotationAngle.value,
                                child: SizedBox(
                                  width: controller.sigWidth.value,
                                  height: controller.sigHeight.value,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      // Dashed border background
                                      Positioned.fill(
                                        child: CustomPaint(
                                          painter: _DashedBorderPainter(),
                                        ),
                                      ),

                                      // Signature image or demo painter
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: ClipRect(
                                          child: SizedBox(
                                            width:
                                                controller.sigWidth.value - 8,
                                            height:
                                                controller.sigHeight.value - 8,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                if (controller
                                                    .signatureMessage
                                                    .isNotEmpty)
                                                  Text(
                                                    controller.signatureMessage,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                Expanded(
                                                  child:
                                                      controller
                                                          .signatureBytes
                                                          .isEmpty
                                                      ? CustomPaint(
                                                          painter:
                                                              _DemoSignaturePainter(),
                                                        )
                                                      : Image.memory(
                                                          controller
                                                              .signatureBytes,
                                                          fit: BoxFit.contain,
                                                        ),
                                                ),
                                                if (controller
                                                    .signatureDate
                                                    .isNotEmpty)
                                                  Flexible(
                                                    flex: 0,
                                                    child: Text(
                                                      controller.signatureDate,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: blackColor,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Red dot – floating center-top (indicator/anchor)

                                      // White circle with black border – top-right corner
                                      Positioned(
                                        top: -5,
                                        right: -5,
                                        child: _DotHandle(
                                          color: whiteColor,
                                          border: Border.all(
                                            color: secondryColor,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),

                                      // Black circle – bottom-right corner (resize handle)
                                      Positioned(
                                        bottom: -5,
                                        right: -5,
                                        child: GestureDetector(
                                          onPanUpdate: (d) {
                                            controller.updateSizeFromCorner(
                                              d.delta.dx,
                                              d.delta.dy,
                                            );
                                          },
                                          child: const _DotHandle(
                                            color: blackColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),

                        // ── X, Y coordinates – bottom-left ──
                        Positioned(
                          bottom: 1.h,
                          left: 4.w,
                          child: Obx(
                            () => customText(
                              text:
                                  'X ${controller.xPosition.value.toInt()}, '
                                  'Y ${controller.yPosition.value.toInt()}',
                              fontSize: 11.4.sp,
                              fontWeight: FontWeight.w600,
                              color: buttonColor,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),

                        // ── Scale & Rotation – bottom-right ──
                        Positioned(
                          bottom: 1.h,
                          right: 4.w,
                          child: Obx(
                            () => customText(
                              text:
                                  'Scale: ${controller.scalePercentage}%, '
                                  'Rotation: ${controller.rotationDegrees}%',
                              fontSize: 11.4.sp,
                              fontWeight: FontWeight.w600,
                              color: buttonColor,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 1.5.h),

            // ──────────── Page Navigation ────────────
            const Spacer(),

            // ──────────── Rotate Button ────────────
            GestureDetector(
              onTap: controller.rotateSignature,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: bottomNavColor, width: 0.8),
                    ),
                    child: Icon(
                      Icons.refresh_rounded,
                      weight: 2,
                      color: bottomNavColor,
                      size: 5.w,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Obx(
                    () => customText(
                      text: 'Rotate : ${controller.rotationDegrees}%',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: bottomNavColor,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // ──────────── Confirm Signature Button ────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              child: buttonWidget(
                'Confirm Signature',
                whiteColor,
                colors: buttonColor,
                onTap: () => controller.confirmPlacement(context),
                fontFamily: 'Poppins',
                height: 5.5.h,
                width: double.infinity,
                fontsize: 16.sp,
                fontweight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}

// ─────────── Helper Widgets ───────────

class _DotHandle extends StatelessWidget {
  final Color color;
  final BoxBorder? border;
  const _DotHandle({required this.color, this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 11,
      height: 11,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: border,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = secondryColor.withAlpha(80)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(8.0),
        ),
      );

    const dashWidth = 4.0;
    const dashSpace = 3.0;

    for (final pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final len = (distance + dashWidth < pathMetric.length)
            ? dashWidth
            : pathMetric.length - distance;
        canvas.drawPath(
          pathMetric.extractPath(distance, distance + len),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DemoSignaturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final cx = size.width * 0.12;
    final cy = size.height * 0.55;
    path.moveTo(cx, cy);
    path.cubicTo(cx + 12, cy - 16, cx + 24, cy + 16, cx + 36, cy);
    path.cubicTo(cx + 48, cy - 16, cx + 60, cy + 16, cx + 72, cy);
    path.cubicTo(cx + 84, cy - 16, cx + 96, cy + 16, cx + 108, cy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
