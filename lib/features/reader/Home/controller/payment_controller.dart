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
    final token =
        SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
    final uri = Uri.parse(
      '${BaseService().baseURL}${ApiEndPoints.readerStripePayment}',
    );

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'paymentIntentId': paymentIntentId}),
    );

    debugPrint("Confirm Payment Response: ${response.statusCode} - ${response.body}");

    // YAHAN CHANGE KIYA HAI (200 OR 201 dono success hain)
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Payment confirmation failed with status: ${response.statusCode}');
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
          paymentIntentClientSecret: clientSecret.trim(), // .trim() zaroori hai
          merchantDisplayName: 'StorySign',
          billingDetails: BillingDetails(
            name: 'StorySign User',
          ), // Kabhi kabhi ye zaroori hota hai
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
      Utils.showToast("Payment failed", true);
      return false;
    } finally {
      isPaymentLoading.value = false;
    }
  }
}
