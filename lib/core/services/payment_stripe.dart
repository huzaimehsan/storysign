import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

class PaymentService {
  Future<void> makePayment(String clientSecret) async {
    try {
      // 1. Payment Sheet Initialize
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'StorySign',
        ),
      );

      // 2. Present Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      Get.snackbar("Success", "Payment Successful!");
    } catch (e) {
      Get.snackbar("Error", "Payment failed: $e");
    }
  }
}