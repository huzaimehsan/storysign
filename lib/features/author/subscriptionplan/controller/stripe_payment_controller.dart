import 'package:flutter/cupertino.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import 'package:storysign/utils/shared_prefrences_methods.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/utility.dart';
import '../../../../constants/local_db_key.dart';
import '../../home/controller/home_controller.dart';
import '../../profile/controller/profile_controller.dart';

class StripePaymentController extends GetxController {
  RxBool isPaymentLoading = false.obs;

  Future<Map<String, dynamic>> createPaymentIntent(String planId) async {
    try {
      final response = await BaseService().basePostAPI(
        ApiEndPoints.checkOutPayment,
        {'planId': planId},
      );

      if (response['success'] == true) {
        final String? clientSecret = response['clientSecret']?.toString();
        final String? paymentIntentId = response['paymentIntentId']?.toString();

        if (clientSecret == null || clientSecret.isEmpty) {
          Utils.showToast('Client secret missing in response', true);
          throw Exception('Client secret missing');
        }

        return {
          'clientSecret': clientSecret,
          'paymentIntentId': paymentIntentId,
        };
      } else {
        throw Exception(
          'Failed to create payment intent: ${response['message']}',
        );
      }
    } catch (e) {
      Utils.showToast('Error: $e', true);
      rethrow;
    }
  }

  Future<void> confirmSubscriptionPayment(String paymentIntentId) async {
    try {
      final response = await BaseService().basePostAPI(
        ApiEndPoints.confirmSubscriptionPayment,
        {'paymentIntentId': paymentIntentId},
      );

      if (response['success'] == true) {
        // Correctly save the isSubscribed flag so the app knows on restart
        await SharedPreferencesMethod.setBool(
          key: LocalDBKeys.IS_SUBSCRIBED,
          value: true,
        );
        debugPrint("Saved IS_SUBSCRIBED = true");

        Utils.showToast('Subscription activated successfully', false);
      } else {
        throw Exception(
          'Failed to confirm subscription payment: ${response['message']}',
        );
      }
    } catch (e) {
      Utils.showToast('Error: $e', true);
      rethrow;
    }
  }

  Future<bool> processPayment(String planId) async {
    isPaymentLoading.value = true;
    try {
      debugPrint('Payment flow start: planId=$planId');
      final result = await createPaymentIntent(planId);
      final clientSecret = result['clientSecret'] as String;
      final paymentIntentId = result['paymentIntentId'] as String;
      debugPrint('Payment intent created: paymentIntentId=$paymentIntentId');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'StorySign',
        ),
      );
      debugPrint('Payment sheet initialized');

      await Stripe.instance.presentPaymentSheet();
      debugPrint('Payment sheet presented');
      await confirmSubscriptionPayment(paymentIntentId);
      debugPrint('Subscription confirmation complete');

      // Refresh live controllers so plan screen reflects new active plan immediately
      if (Get.isRegistered<AuthorHomeController>()) {
        await Get.find<AuthorHomeController>().fetchSubscriptionPlan();
      }
      if (Get.isRegistered<AuthorProfileController>()) {
        await Get.find<AuthorProfileController>().getProfile();
      }

      Get.snackbar('Success', 'Payment completed successfully');
      return true;
    } on StripeException catch (e) {
      Get.snackbar(
        'Payment Failed',
        e.error.localizedMessage ?? 'Payment was cancelled or failed',
      );
      debugPrint('StripeException during payment: ${e.error.localizedMessage}');
      return false;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      debugPrint('Exception during processPayment: $e');
      return false;
    } finally {
      isPaymentLoading.value = false;
    }
  }
}
