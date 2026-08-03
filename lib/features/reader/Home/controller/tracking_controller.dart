import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:storysign/features/reader/Home/model/tracking_model.dart';

import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/utility.dart';

class TrackingController extends GetxController {
  RxBool isloading = false.obs;
  String? autographRequestId;
  RxString errorMessage = ''.obs;
  Rxn<TrackingModel> trackingModel = Rxn<TrackingModel>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      autographRequestId = args['autographRequestId']?.toString() ?? args['bookId']?.toString();

      debugPrint('Controller onInit: ID received -> $autographRequestId');

      if (autographRequestId != null && autographRequestId!.isNotEmpty) {
        trackingDetail(autographRequestId);
      }
    }
  }Future<void> trackingDetail(String? requestId) async {
    final normalizedId = requestId?.trim();
    if (normalizedId == null || normalizedId.isEmpty) {
      errorMessage.value = 'Request id not found';
      return;
    }

    try {
      isloading.value = true;

      final endpoint = ApiEndPoints.getAutographRequestDetails(normalizedId);
      debugPrint('Tracking endpoint: $endpoint');

      final response = await BaseService().baseGetAPI(endpoint, loading: false);
      debugPrint('Tracking raw response: $response');

      if (response['success'] == true) {
        final parsed = TrackingModel.fromResponse(response);
        if (parsed != null) {
          trackingModel.value = parsed;
          debugPrint('Parsed OK: ${parsed.bookTitle}, ${parsed.author?.fullName}');
        } else {
          throw Exception('Failed to parse tracking data');
        }
      } else {
        throw Exception(response['message']?.toString() ?? 'Server Error');
      }
    } catch (e, stackTrace) {
      debugPrint('Error: $e');
      debugPrint('StackTrace: $stackTrace'); //
      errorMessage.value = 'Something went wrong';
    } finally {
      isloading.value = false;
    }
  }
}