import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/constants/color_constants.dart';
import 'package:storysign/widgets/button_widget.dart';
import 'package:storysign/widgets/customText_widget.dart';
import 'package:storysign/widgets/subscription_header_widget.dart';
import 'package:storysign/widgets/sucess_widget.dart';

import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../services/request_service.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';

import '../controller/place_signature_controller.dart';
import '../controller/add_message_controller.dart';
import '../widgets/ready_to_send_card.dart';
import '../widgets/signature_detail_card.dart';

class AuthorFinalReviewScreen extends StatelessWidget {
  const AuthorFinalReviewScreen({super.key});

  Future<void> _approveAndSend(BuildContext context) async {
    final reqService = RequestService.find;
    final messageCtrl = Get.find<AddMessageController>();
    final placeCtrl = Get.find<PlaceSignatureController>();

    final String autographRequestId = reqService.autographRequestId;

    if (autographRequestId.isEmpty) {
      Utils.showToast('Request ID is missing', true);
      return;
    }

    final bytes = reqService.signatureBytes ?? placeCtrl.signatureBytes;
    if (bytes.isEmpty) {
      Utils.showToast('Signature is missing', true);
      return;
    }

    try {
      EasyLoading.show(
        status: 'Submitting signed PDF...',
        maskType: EasyLoadingMaskType.black,
      );

      final prefs = SharedPreferencesMethod.storage;
      final String token = prefs.getString(LocalDBKeys.TOKEN) ?? '';

      final uri = Uri.parse(
        '${BaseService().baseURL}${ApiEndPoints.approveSendAutographRequest(autographRequestId)}',
      );

      print('⏳ APPROVE SEND API URL: $uri');

      final request = http.MultipartRequest('POST', uri);

      if (token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add signature file
      request.files.add(
        http.MultipartFile.fromBytes(
          'signatureImage',
          bytes,
          filename: 'signature.png',
          contentType: MediaType('image', 'png'),
        ),
      );

      // Add form fields as defined in API schema
      request.fields['pageIndex'] = reqService.pageIndex.toString();
      request.fields['xRatio'] = reqService.xRatio.toString();
      request.fields['yRatio'] = reqService.yRatio.toString();
      request.fields['widthRatio'] = reqService.widthRatio.toString();
      request.fields['heightRatio'] = reqService.heightRatio.toString();
      request.fields['pageWidthPts'] = reqService.pageWidthPts.toInt().toString();
      request.fields['pageHeightPts'] = reqService.pageHeightPts.toInt().toString();
      request.fields['authorMessage'] = messageCtrl.messageController.text.trim();

      print('➡ APPROVE SEND FIELDS: ${request.fields}');

      final streamedResponse = await request.send().timeout(const Duration(seconds: 60));
      final responseString = await streamedResponse.stream.bytesToString();
      final responseMap = json.decode(responseString);

      print('✅ APPROVE SEND STATUS: ${streamedResponse.statusCode}');
      print('✅ APPROVE SEND RESPONSE: $responseMap');

      if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201) {
        reqService.clear();
        finalReviewSucess(
          context,
          desc: responseMap['message'] ?? "Signed Ebook has been sent successfully",
        );
      } else {
        Utils.showToast(responseMap['message'] ?? 'Failed to approve and send', true);
      }
    } on TimeoutException {
      Utils.showToast('Request timed out', true);
    } catch (e) {
      print('Approve & Send Error: $e');
      Utils.showToast('Something went wrong while sending', true);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void _makeChanges(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final placeCtrl = Get.find<PlaceSignatureController>();
    final messageCtrl = Get.find<AddMessageController>();
    final reqService = RequestService.find;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: customHeaderAuthor(
                context: context,
                title: 'Final Review',
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

            // ── Section 1: Ready to Send ──
            SizedBox(height: 1.5.h),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      text: 'Ready to Send',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                      color: whiteColor,
                      fontFamily: 'Poppins',
                    ),
                    SizedBox(height: 1.5.h),
                    ReadyToSendCard(
                      readerName: reqService.readerName.isNotEmpty
                          ? reqService.readerName
                          : 'Jane Austen',
                      readerImagePath: reqService.readerImagePath.isNotEmpty
                          ? reqService.readerImagePath
                          : 'assets/png/searchprofile.png',
                      ebookTitle: reqService.bookTitle.isNotEmpty
                          ? reqService.bookTitle
                          : 'Things Fall Apart',
                      bookImagePath: reqService.coverImage.isNotEmpty
                          ? reqService.coverImage
                          : 'assets/png/book.png',
                    ),

                      SizedBox(height: 3.h),

                      // ── Section 2: Ebook Detail ──
                      customText(
                        text: 'Ebook Detail',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: whiteColor,
                        letterSpacing: 0,
                        fontFamily: 'Poppins',
                      ),
                      SizedBox(height: 1.5.h),

                      SignatureDetailCard(
                        currentPage: placeCtrl.currentPage,
                        signatureBytes: placeCtrl.signatureBytes,
                      ),
                      SizedBox(height: 2.5.h),

                      // ── Section 3: Message ──
                      customText(
                        text: 'Message',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: whiteColor,
                        fontFamily: 'Poppins',
                      ),
                      SizedBox(height: 1.5.h),

                      // Message card
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
                                text:
                                '${messageCtrl.charCount.value} Characters',
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

                      // ── Button 1: Approve and Send ──
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

                      // ── Button 2: Make Changes ──
                      buttonWidget(
                        "Make Changes",
                        whiteColor,
                        colors: greyColor,
                        fontFamily: 'Poppins',
                        onTap:    (){

                          Navigator.of(context).pushNamed('/drawSignature');
                        },
                        height: 5.5.h,
                        width: double.infinity,
                        fontsize: 16.sp,
                        fontweight: FontWeight.w600,
                      ),
                      SizedBox(height: 3.h),

                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),

            ],
          ),

      ),
    );
  }
}
