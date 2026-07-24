import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../core/services/request_service.dart';
import '../../../../utils/shared_prefrences_methods.dart';
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
}