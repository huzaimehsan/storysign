import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';
import '../model/home_model.dart';

class ReaderDetailController extends GetxController {
  String? autographRequestId;

  RxBool isloading = false.obs;
  RxString errorMessage = ''.obs;
  Rxn<NewBookItem> selectedRequest = Rxn<NewBookItem>();


  @override
  void onInit() {
    super.onInit();

    var args = Get.arguments;
    if (args != null && args is Map) {
      // Check karein autographRequestId, agar na mile to bookId utha lein
      autographRequestId = args['autographRequestId'] ?? args['bookId'];

      debugPrint('Controller onInit: ID received -> $autographRequestId');

      if (autographRequestId != null && autographRequestId!.isNotEmpty) {
        authorDetail(autographRequestId);
      }
    }
  }

  Future<void> authorDetail(String? requestId) async {
    final normalizedId = requestId?.trim();
    if (normalizedId == null || normalizedId.isEmpty) {
      errorMessage.value = 'Request id not found';
      return;
    }

    try {
      isloading.value = true;

      final endpoint = ApiEndPoints.getAutographRequestDetails(normalizedId);
      final response = await BaseService().baseGetAPI(endpoint, loading: false);

      if (response['success'] == true) {
        final parsedRequest = NewBookItem.fromResponse(response);

        if (parsedRequest != null) {
          selectedRequest.value = parsedRequest;
        } else {
          throw Exception('Failed to parse data');
        }
      } else {
        throw Exception(response['message']?.toString() ?? 'Server Error');
      }
    } catch (e) {
      debugPrint('Error: $e');
      errorMessage.value = 'Something went wrong';
      // baseGetAPI already error case mein specific toast dikha chuka hoga —
      // isliye yahan generic toast dobara mat lagao, warna double toast aayega.
      // Sirf tab dikhao jab error humara apna hai (jaise parsing fail):
      if (e.toString().contains('Failed to parse data')) {
        Utils.showToast(errorMessage.value, true);
      }
    } finally {
      isloading.value = false;
    }
  }
  // Future<void> authorDetail(String? requestId) async {
  //   final normalizedId = requestId?.trim();
  //   if (normalizedId == null || normalizedId.isEmpty) {
  //     errorMessage.value = 'Request id not found';
  //     return;
  //   }
  //
  //   try {
  //     isloading.value = true;
  //     EasyLoading.show(status: 'Loading...'); // Loading spinner start
  //
  //     final token = SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
  //
  //     if (token.isEmpty) {
  //       throw Exception('User not logged in');
  //     }
  //
  //     final endpoint = ApiEndPoints.getAutographRequestDetails(normalizedId);
  //     final uri = Uri.parse('${BaseService().baseURL}$endpoint');
  //
  //     final response = await http.get(
  //       uri,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final decodedBody = jsonDecode(response.body);
  //
  //       // Ensure fromResponse handles the map correctly
  //       final parsedRequest = BookItem.fromResponse(decodedBody);
  //
  //       if (parsedRequest != null) {
  //         selectedRequest.value = parsedRequest;
  //       } else {
  //         throw Exception('Failed to parse data');
  //       }
  //     } else {
  //       throw Exception('Server Error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     debugPrint('Error: $e');
  //     errorMessage.value = 'Something went wrong';
  //     Utils.showToast(errorMessage.value, true);
  //   } finally {
  //     isloading.value = false;
  //     EasyLoading.dismiss(); // Loading spinner end
  //   }
  // }
  //
  //
  // Future<void> processPayment({
  //   required String clientSecret,
  //   required String paymentIntentId,
  //   required VoidCallback onSuccess,
  // }) async {
  //   try {
  //     // 1. Stripe Payment Sheet Initialize
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: clientSecret,
  //         merchantDisplayName: 'StorySign',
  //       ),
  //     );
  //
  //     // 2. Show Payment Sheet
  //     await Stripe.instance.presentPaymentSheet();
  //
  //     // 3. Server Verification
  //     final BaseService baseService = BaseService();
  //     final response = await baseService.(paymentIntentId);
  //
  //     if (response['success'] == true) {
  //       Utils.showToast("Payment Successful!", false);
  //       onSuccess(); // Yeh callback UI ya original controller ko update karega
  //     }
  //   } on StripeException catch (e) {
  //     debugPrint('Stripe Error: $e');
  //     Utils.showToast('Payment Cancelled', true);
  //   } catch (e) {
  //     debugPrint('Error: $e');
  //   }
  // }
}