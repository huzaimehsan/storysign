import 'dart:async';
import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:storysign/features/author/request/model/request_detail_model.dart';

import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../core/services/request_service.dart';
import '../../../../utils/utility.dart';

Map<String, String> normalizeRequestDetailArgs(Object? args) {
  final normalized = <String, String>{
    'from': '',
    'autographRequestId': '',
  };

  if (args is Map) {
    final fromValue = args['from'] ?? args['source'] ?? '';
    final idValue = args['autographRequestId'] ?? args['id'] ?? args['requestId'] ?? '';

    normalized['from'] = fromValue?.toString().trim() ?? '';
    normalized['autographRequestId'] = idValue?.toString().trim() ?? '';
  } else if (args is String) {
    normalized['autographRequestId'] = args.trim();
  }

  return normalized;
}

class RequestDetailController extends GetxController {

  // .obs variable
  var sourceScreen = ''.obs;
  RxString errorMessage = ''.obs;
  String autographRequestId = '';

  // Use this method from your screen's didChangeDependencies to receive values safely
  void initData(String from, String id) {
    final cleanedFrom = from.trim();
    final cleanedId = id.trim();

    if (sourceScreen.value == cleanedFrom &&
        autographRequestId == cleanedId &&
        selectedRequestDetail.value != null) {
      return;
    }

    sourceScreen.value = cleanedFrom;
    autographRequestId = cleanedId;

    print("SOURCE SCREEN IS: ${sourceScreen.value}");
    print("AUTOGRAPH REQUEST ID: $autographRequestId");

    if (autographRequestId.isNotEmpty) {
      fetchAutographRequestDetails(autographRequestId);
    } else {
      selectedRequestDetail.value = null;
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

      print("[Controller] Fetching details for ID: $autographRequestId");
      print("[Controller] URL will be: /author/requests/$autographRequestId");

      final response = await BaseService().baseGetAPI(
        ApiEndPoints.autographRequestDetails(autographRequestId),
        loading: false,
        showErrorToast: false,
      );

      print("API Response: $response");

      if (response['success'] == true) {
        final responseBody = response;

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
        final responseBody = response;
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
    } catch (e, stackTrace) {
      debugPrint('[RequestDetail] CATCH ERROR: $e');
      debugPrint('[RequestDetail] STACK TRACE: $stackTrace');
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

      final response = await BaseService().basePostAPI(
        ApiEndPoints.rejectAutographRequest(autographRequestId),
        {
          'rejectionReason': reason ?? 'I am not accepting this genre at the moment.',
        },
        loading: false,
      );

      print("REJECT Response: $response");

      if (response['success'] == true) {
        Utils.showToast(response['message'] ?? 'Request declined successfully', false);
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          Get.back();
        }
      } else {
        Utils.showToast(response['message'] ?? 'Failed to decline request', true);
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