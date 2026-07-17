import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';
import '../../../author/subscriptionplan/controller/subscription_plan_controller.dart';
import '../../library/model/library_model.dart';

import 'package:http/http.dart' as http;
class PaymentController extends GetxController {



  var isPaymentLoading = false.obs;

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

  // 👇 Poori payment logic yahan — widget sirf ise call karega
  Future<bool> processPayment() async {
    final subscriptionController = Get.find<SubscriptionPlanController>();
    final plan = subscriptionController.selectedPlan.value;

    if (plan == null) {
      Get.snackbar('Error', 'No plan selected');
      return false;
    }

    isPaymentLoading.value = true;
    try {
      // Step 1: checkout — get clientSecret + paymentIntentId
      final result = await createPaymentIntent(plan.id);
      final clientSecret = result['clientSecret'] as String;
      final paymentIntentId = result['paymentIntentId'] as String;

      // Step 2: initialize Stripe's payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'StorySign',
        ),
      );

      // Step 3: present the sheet to the user
      await Stripe.instance.presentPaymentSheet();

      // Step 4: no exception thrown = payment succeeded, confirm with backend
      await confirmSubscriptionPayment(paymentIntentId);

      Get.snackbar('Success', 'Payment completed successfully');
      return true;
    } on StripeException catch (e) {
      Get.snackbar(
        'Payment Failed',
        e.error.localizedMessage ?? 'Payment was cancelled or failed',
      );
      return false;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isPaymentLoading.value = false;
    }
  }
//   var isPaymentLoading = false.obs;
//
//
//   Future<bool> processPayment(String requestId) async {
//     isPaymentLoading.value = true;
//     try {
//       // 1. API Call: RequestID bhej kar Backend se Intent details mangwayein
//       final response = await http.post(
//         Uri.parse('${BaseService().baseURL}${ApiEndPoints.readerStripePayment}'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN)}',
//         },
//         body: jsonEncode({'requestId': requestId}),
//       );
//
//       if (response.statusCode != 200) throw Exception("Failed to get PaymentIntent");
//
//       final res = jsonDecode(response.body);
//       final String clientSecret = res['clientSecret'];
//       final String paymentIntentId = res['paymentIntentId']; // 👈 Yeh ID aapko backend se milegi
//
//       // 2. Stripe Init
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: clientSecret,
//           merchantDisplayName: 'StorySign',
//         ),
//       );
//
//       // 3. Present Sheet
//       await Stripe.instance.presentPaymentSheet();
//
//       // 4. Confirm Payment (Wahi ID jo upar backend se mili thi)
//       await confirmAutographPayment(paymentIntentId);
//
//       return true;
//     } catch (e) {
//       return false;
//     } finally {
//       isPaymentLoading.value = false;
//     }
//   }
// // Yeh function aapke PaymentController class ke andar defined hai:
//
//   Future<void> confirmAutographPayment(String paymentIntentId) async {
//     try {
//       final token = SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
//       if (token.isEmpty) {
//         Utils.showToast('Please login again', true);
//         throw Exception('No auth token found');
//       }
//
//       final uri = Uri.parse('${BaseService().baseURL}${ApiEndPoints.readerStripePayment}');
//
//       final response = await http.post(
//         uri,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({'paymentIntentId': paymentIntentId}),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         Utils.showToast('Payment confirmed successfully', false);
//       } else {
//         Utils.showToast('Error: ${response.statusCode}', true);
//         throw Exception('Failed to confirm payment: ${response.body}');
//       }
//     } catch (e) {
//       Utils.showToast('Error: $e', true);
//       rethrow;
//     }
//   }
//
}