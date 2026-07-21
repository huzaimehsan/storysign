import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';

class StripePaymentController extends GetxController {
  RxBool isPaymentLoading = false.obs;

  Future<Map<String, dynamic>> createPaymentIntent(String planId) async {
    try {
      final token = SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
      if (token.isEmpty) {
        Utils.showToast('Please login again', true);
        throw Exception('No auth token found');
      }

      final uri = Uri.parse('${BaseService().baseURL}${ApiEndPoints.checkOutPayment}');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'planId': planId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        final String? clientSecret = responseBody['clientSecret']?.toString();
        final String? paymentIntentId = responseBody['paymentIntentId']?.toString();

        if (clientSecret == null || clientSecret.isEmpty) {
          Utils.showToast('Client secret missing in response', true);
          throw Exception('Client secret missing');
        }

        return {
          'clientSecret': clientSecret,
          'paymentIntentId': paymentIntentId,
        };
      } else {
        Utils.showToast('Error: ${response.statusCode}', true);
        throw Exception('Failed to create payment intent: ${response.body}');
      }
    } catch (e) {
      Utils.showToast('Error: $e', true);
      rethrow;
    }
  }

  Future<void> confirmSubscriptionPayment(String paymentIntentId) async {
    try {
      final token = SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
      if (token.isEmpty) {
        Utils.showToast('Please login again', true);
        throw Exception('No auth token found');
      }

      final uri = Uri.parse('${BaseService().baseURL}${ApiEndPoints.confirmSubscriptionPayment}');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'paymentIntentId': paymentIntentId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Utils.showToast('Subscription activated successfully', false);
      } else {
        Utils.showToast('Error: ${response.statusCode}', true);
        throw Exception('Failed to confirm subscription payment: ${response.body}');
      }
    } catch (e) {
      Utils.showToast('Error: $e', true);
      rethrow;
    }
  }

  Future<bool> processPayment(String planId) async {
    isPaymentLoading.value = true;
    try {
      final result = await createPaymentIntent(planId);
      final clientSecret = result['clientSecret'] as String;
      final paymentIntentId = result['paymentIntentId'] as String;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'StorySign',
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      await confirmSubscriptionPayment(paymentIntentId);
      Get.snackbar('Success', 'Payment completed successfully');
      return true;
    } on StripeException catch (e) {
      Get.snackbar('Payment Failed', e.error.localizedMessage ?? 'Payment was cancelled or failed');
      return false;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isPaymentLoading.value = false;
    }
  }
}
