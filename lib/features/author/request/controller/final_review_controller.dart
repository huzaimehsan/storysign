import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../core/services/request_service.dart';
import '../../../../utils/utility.dart';
import '../../../../widgets/sucess_widget.dart';
import './add_message_controller.dart';
import './place_signature_controller.dart';

class FinalReviewController extends GetxController {
  Future<void> approveAndSend(BuildContext context) async {
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

      final request = await BaseService().buildMultipartRequest(
        ApiEndPoints.approveSendAutographRequest(autographRequestId),
      );

      print('⏳ APPROVE SEND API URL: ${request.url}');

      request.files.add(
        http.MultipartFile.fromBytes(
          'signatureImage',
          bytes,
          filename: 'signature.png',
          contentType: http.MediaType('image', 'png'),
        ),
      );

      request.fields['pageIndex'] = reqService.pageIndex.toString();
      request.fields['xRatio'] = reqService.xRatio.toString();
      request.fields['yRatio'] = reqService.yRatio.toString();
      request.fields['widthRatio'] = reqService.widthRatio.toString();
      request.fields['heightRatio'] = reqService.heightRatio.toString();
      request.fields['pageWidthPts'] = reqService.pageWidthPts.toInt().toString();
      request.fields['pageHeightPts'] = reqService.pageHeightPts.toInt().toString();
      request.fields['authorMessage'] = messageCtrl.messageController.text.trim();

      print('➡ APPROVE SEND FIELDS: ${request.fields}');

      final responseMap = await BaseService().baseMultipartPostAPI(
        ApiEndPoints.approveSendAutographRequest(autographRequestId),
        request: request,
        loading: false,
      );

      print('✅ APPROVE SEND RESPONSE: $responseMap');

      if (responseMap['success'] == true) {
        reqService.clear();
        finalReviewSucess(
          context,
          desc: responseMap['message'] ?? 'Signed Ebook has been sent successfully',
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
}