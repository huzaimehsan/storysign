import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/constants/color_constants.dart';
import 'package:storysign/widgets/button_widget.dart';
import 'package:storysign/widgets/customText_widget.dart';
import 'package:storysign/widgets/subscription_header_widget.dart';

import 'package:storysign/widgets/sucess_widget.dart';

import '../controller/place_signature_controller.dart';
import '../controller/add_message_controller.dart';

class AuthorFinalReviewScreen extends StatelessWidget {
  const AuthorFinalReviewScreen({super.key});

  void _approveAndSend(BuildContext context) {
    finalReviewSucess(
      context,

      desc: "Signed Ebook has been sent successfully",
    );
  }

  void _makeChanges() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final placeCtrl = Get.find<PlaceSignatureController>();
    final messageCtrl = Get.find<AddMessageController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                customHeaderAuthor(
                  context: context,
                  title: 'Final Review',
                  onBack: () => Get.back(),
                  onIconPressed: () {},
                ),
                SizedBox(height: 3.h),

                // Section 1: Ready to Send
                customText(
                  text: 'Ready to Send',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                  color: whiteColor,
                  fontFamily: 'Poppins',
                ),
                SizedBox(height: 1.5.h),

                // Card 1: Reader & Ebook info
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 3.w,horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: white, // warm cream Color(0xFFFBF0E3)
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                  child: Column(
                    children: [
                      // Reader Row
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 6.w,
                            backgroundImage: const AssetImage('assets/png/searchprofile.png'),
                            backgroundColor: buttonColor.withAlpha(30),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: primaryColor.withOpacity(0.7),
                                  fontFamily: 'Poppins',

                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Reader: ',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Jane Austen',
                                    style: TextStyle(
                                      color: secondryColor,
                                      fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    ),

                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),

                      // Ebook Row
                      Row(
                        children: [
                          Container(
                            height: 12.w,
                            width: 12.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.w),
                              image: const DecorationImage(
                                image: AssetImage('assets/png/book.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: primaryColor.withOpacity(0.7),
                                  fontFamily: 'Poppins',
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Ebook: ',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Things Fall Apart',
                                    style: TextStyle(
                                      color: secondryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),

                // Section 2: Ebook Detail
                customText(
                  text: 'Ebook Detail',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: whiteColor,
                  letterSpacing: 0,
                  fontFamily: 'Poppins',
                ),
                SizedBox(height: 1.5.h),

                // Card 2: Signature Placement info
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4.w,),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Detail labels
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
                              textAlign: TextAlign.center,
                              fontFamily: 'Poppins',
                            ),
                            SizedBox(height: 0.5.h),
                            Obx(() => customText(
                                  text: 'Placed on the page ${placeCtrl.currentPage.value}. Center Right',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: primaryColor.withOpacity(0.7),
                                  fontFamily: 'Poppins',
                                )),
                          ],
                        ),
                      ),

                      // Signature preview
                      Container(
                        height: 10.h,
                        width: 25.w,
                        alignment: Alignment.center,
                        child: placeCtrl.signatureBytes.isEmpty
                            ? CustomPaint(
                                size: Size(20.w, 6.h),
                                painter: _SquigglePainter(),
                              )
                            : Image.memory(
                                placeCtrl.signatureBytes,
                                fit: BoxFit.contain,
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),

                // Section 3: Message
                customText(
                  text: 'Message',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: whiteColor,
                  fontFamily: 'Poppins',
                ),
                SizedBox(height: 1.5.h),

                // Card 3: Saved Message info
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        text: messageCtrl.messageController.text,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: textFeildColor,

                        height: 1.5,
                      ),
                      SizedBox(height: 1.5.h),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Obx(() => customText(
                              text: '${messageCtrl.charCount.value} Characters',
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: buttonColor,
                              fontFamily: 'Poppins',
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),

                // Button 1: Approve and Send
                buttonWidget(
                  "Approve and Send",
                  whiteColor,
                  colors: buttonColor,
                  onTap: () => _approveAndSend(context),
                  fontFamily: 'Poppins',
                  height: 5.5.h,
                  width: double.infinity,
                  fontsize: 16.sp,
                  fontweight: FontWeight.w600,
                ),
                SizedBox(height: 1.8.h),

                // Button 2: Make Changes
                buttonWidget(
                  "Make Changes",
                  whiteColor,
                  colors: greyColor,
                  onTap: _makeChanges,
                  fontFamily: 'Poppins',
                  height: 5.5.h,
                  width: double.infinity,
                  fontsize: 16.sp,
                  fontweight: FontWeight.w600,
                ),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Squiggle painter for fallback signature preview
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
