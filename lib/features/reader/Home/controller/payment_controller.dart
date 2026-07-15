// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
//
// import '../../../../core/services/base_services.dart';
// import '../../../../utils/utility.dart';
// import '../../library/model/library_model.dart';
//
// class PaymentController extends GetxController {
//
//   Future<void> processStripePayment(BookItem data) async {
//     try {
//       EasyLoading.show(status: "Processing payment...");
//
//       // 1. Backend se PaymentIntent create karwana
//       final paymentData =
//       await BaseService().createPaymentIntent(
//         data.feeAmount * 100,
//       );
//
//
//       final String? clientSecret =
//       paymentData["clientSecret"];
//
//
//       final String? paymentIntentId =
//       paymentData["paymentIntentId"];
//
//
//       if (clientSecret == null || clientSecret.isEmpty) {
//         throw Exception("Client secret not received");
//       }
//
//
//       if (paymentIntentId == null || paymentIntentId.isEmpty) {
//         throw Exception("Payment intent id not received");
//       }
//
//
//       // 2. Stripe Payment Sheet initialize
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters:
//         SetupPaymentSheetParameters(
//
//           paymentIntentClientSecret:
//           clientSecret,
//
//           merchantDisplayName:
//           "StorySign",
//
//           style:
//           ThemeMode.light,
//         ),
//       );
//
//
//       // 3. Stripe Payment Sheet open
//       await Stripe.instance.presentPaymentSheet();
//
//
//       // 4. Backend par payment confirm
//       final response =
//       await BaseService().confirmAutographPayment(
//         paymentIntentId,
//       );
//
//
//       if (response["success"] == true) {
//
//         Utils.showToast(
//           "Payment Successful",
//           false,
//         );
//
//         authorDetail(
//           autographRequestId,
//         );
//
//       } else {
//
//         Utils.showToast(
//           "Payment verification failed",
//           true,
//         );
//
//       }
//
//
//     } on StripeException catch (e) {
//
//       debugPrint(
//         "Stripe Error: ${e.error.message}",
//       );
//
//       Utils.showToast(
//         e.error.message ?? "Payment cancelled",
//         true,
//       );
//
//
//     } catch (e) {
//
//       debugPrint(
//         "Payment Error: $e",
//       );
//
//       Utils.showToast(
//         e.toString(),
//         true,
//       );
//
//
//     } finally {
//
//       EasyLoading.dismiss();
//
//     }
//   }
// }