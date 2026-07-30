import 'dart:async';
import 'dart:convert';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:storysign/features/author/request/model/request_detail_model.dart';

import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../core/services/request_service.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';

import 'package:http/http.dart' as http;

class RequestDetailController extends GetxController {

  // .obs variable
  var sourceScreen = ''.obs;
  RxString errorMessage = ''.obs;
  String autographRequestId = '';

  // Use this method from your screen's didChangeDependencies to receive values safely
  void initData(String from, String id) {
    sourceScreen.value = from;
    autographRequestId = id;

    print("SOURCE SCREEN IS: ${sourceScreen.value}");
    print("AUTOGRAPH REQUEST ID: $autographRequestId");

    if (autographRequestId.isNotEmpty) {
      fetchAutographRequestDetails(autographRequestId);
    } else {
      print("ERROR: autographRequestId is empty!");
      errorMessage.value = 'Request ID not found';
      Utils.showToast(errorMessage.value, true);
    }
  }

  // Getter mein .value lagayein
  bool get isFromDelivered => sourceScreen.value == 'all_delivered';

  // Single Autograph Request Details fetch karne ke liye Rxn variable
  Rxn<RequestDetailModel> selectedRequestDetail = Rxn<RequestDetailModel>();
  var isFetchDetailLoading = false.obs;

  Future<void> fetchAutographRequestDetails(String autographRequestId) async {
    try {
      isFetchDetailLoading.value = true;
      errorMessage.value = '';

      final prefs = SharedPreferencesMethod.storage;
      final String token = prefs.getString(LocalDBKeys.TOKEN) ?? '';

      if (token.isEmpty) {
        errorMessage.value = 'Token not found';
        Utils.showToast('Please login again', true);
        return;
      }

      // Dynamic endpoint function use karte hue URL banayein
      final uri = Uri.parse(
        '${BaseService().baseURL}${ApiEndPoints.autographRequestDetails(autographRequestId)}',
      );

      print("API URL: $uri");
      print("API TOKEN: $token");

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = jsonDecode(response.body);

        // Agar API direct single object bhej rahi hai ya 'data' key ke andar bhej rahi hai
        final itemJson = responseBody is Map && responseBody.containsKey('data')
            ? responseBody['data']
            : responseBody;

        print("Parsed Item: $itemJson");

        selectedRequestDetail.value = RequestDetailModel.fromJson(itemJson);
        final model = selectedRequestDetail.value;
        if (model != null) {
          RequestService.find.setRequestData(
            autographRequestId,
            pdfUrl: model.bookPdfUrl,
            rName: model.reader.fullName,
            rImage: model.reader.profilePicture,
            bTitle: model.bookTitle,
            cImage: model.coverImage,
          );
        }
        print("Successfully loaded request detail");

      } else {
        final responseBody = jsonDecode(response.body);
        errorMessage.value =
            responseBody['message']?.toString() ?? 'Failed to load request details';
        if (RequestService.find.autographRequestId == autographRequestId &&
            (RequestService.find.bookTitle.isNotEmpty ||
                RequestService.find.readerName.isNotEmpty)) {
          selectedRequestDetail.value = RequestDetailModel(
            id: autographRequestId,
            bookTitle: RequestService.find.bookTitle,
            coverImage: RequestService.find.coverImage,
            bookPdfUrl: RequestService.find.bookPdfUrl,
            signedPdfUrl: null,
            personalMessage: '',
            status: 'accepted',
            rejectionReason: null,
            authorMessage: null,
            requestDate: '',
            feeAmount: 0,
            isPaid: false,
            reader: ReaderModel(
              id: '',
              fullName: RequestService.find.readerName,
              profilePicture: RequestService.find.readerImagePath,
              email: '',
            ),
            author: AuthorDetailModel(
              id: '',
              fullName: '',
              profilePicture: null,
              bio: '',
              dateJoined: '',
            ),
            bookId: '',
          );
        }
        Utils.showToast(errorMessage.value, true);
      }
    } catch (e) {
      debugPrint('Error: $e');
      errorMessage.value = 'Something went wrong while loading details';
      Utils.showToast(errorMessage.value, true);
    } finally {
      isFetchDetailLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  Future<void> rejectRequest(BuildContext context, {String? reason}) async {
    if (autographRequestId.isEmpty) {
      Utils.showToast('Request ID is missing', true);
      return;
    }

    try {
      EasyLoading.show(
        status: 'Declining request...',
        maskType: EasyLoadingMaskType.black,
      );

      final prefs = SharedPreferencesMethod.storage;
      final String token = prefs.getString(LocalDBKeys.TOKEN) ?? '';

      final uri = Uri.parse(
        '${BaseService().baseURL}${ApiEndPoints.rejectAutographRequest(autographRequestId)}',
      );

      print("REJECT API URL: $uri");

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'rejectionReason': reason ?? 'I am not accepting this genre at the moment.',
        }),
      ).timeout(const Duration(seconds: 30));

      print("REJECT Status: ${response.statusCode}");
      print("REJECT Body: ${response.body}");

      final responseBody = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Utils.showToast(responseBody['message'] ?? 'Request declined successfully', false);
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          Get.back();
        }
      } else {
        Utils.showToast(responseBody['message'] ?? 'Failed to decline request', true);
      }
    } on TimeoutException {
      Utils.showToast('Request timed out', true);
    } catch (e) {
      debugPrint('Reject error: $e');
      Utils.showToast('Something went wrong while declining request', true);
    } finally {
      EasyLoading.dismiss();
    }
  }
}