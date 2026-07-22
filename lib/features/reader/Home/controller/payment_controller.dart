import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';

class PaymentController extends GetxController {
  var isPaymentLoading = false.obs;

  Future<void> confirmPayment(String paymentIntentId) async {
    final response = await BaseService().basePostAPI(
      ApiEndPoints.readerStripePayment,
      {'paymentIntentId': paymentIntentId},
      loading: false, // Stripe sheet ke baad apna spinner nahi chahiye
    );

    debugPrint("Confirm Payment Response: $response");

    if (response['success'] != true) {
      throw Exception(
        response['message']?.toString() ?? 'Payment confirmation failed',
      );
    }
  }

  Future<bool> processPayment({
    required String clientSecret,
    required String paymentIntentId,
  }) async {
    isPaymentLoading.value = true;
    try {
      // 1. Double check null ya empty
      if (clientSecret.isEmpty || paymentIntentId.isEmpty) {
        throw Exception("Invalid Payment Details: Secret or ID is empty");
      }

      // 2. Stripe initialization
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret.trim(),
          merchantDisplayName: 'StorySign',
          billingDetails: BillingDetails(name: 'StorySign User'),
        ),
      );

      // 3. Present Sheet
      await Stripe.instance.presentPaymentSheet();

      // 4. Confirm Payment (API call)
      await confirmPayment(paymentIntentId.trim());

      Get.snackbar('Success', 'Payment completed successfully');
      return true;
    } on StripeException catch (e) {
      debugPrint("Stripe Exception: ${e.error.localizedMessage}");
      Utils.showToast("Payment Cancelled: ${e.error.localizedMessage}", true);
      return false;
    } catch (e) {
      debugPrint("General Payment Error: $e");
      // Note: basePostAPI (confirmPayment ke andar) already specific error
      // toast dikha chuka hoga agar server ne error diya — isliye yahan
      // dobara generic toast nahi laga rahe, warna do toasts aayenge.
      // Sirf tab dikhao jab ye Stripe/logic error ho (jaise empty fields):
      if (e.toString().contains('Invalid Payment Details')) {
        Utils.showToast("Payment failed", true);
      }
      return false;
    } finally {
      isPaymentLoading.value = false;
    }
  }
}
