import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';
import '../model/subscription_model.dart';

class SubscriptionPlanController extends GetxController {
  // Observables
  var isYearly = false.obs;
  var isLoading = false.obs;
  var plans = <SubscriptionPlan>[].obs; // API se aane wala data yahan hoga
  var selectedPlan = Rx<SubscriptionPlan?>(null);





  @override
  void onInit() {
    super.onInit();
    // Default load monthly
    fetchSubscriptionPlans('monthly');
  }


  // Future<String> createPaymentIntent(String planId,{
  //
  //   required String currency,
  // }) async {
  //   try {
  //     final token = SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
  //     if (token.isEmpty) {
  //       Utils.showToast('Please login again', true);
  //       throw Exception('No auth token found');
  //     }
  //
  //     final uri = Uri.parse('${BaseService().baseURL}${ApiEndPoints.checkOutPayment}');
  //     // ^ adjust endpoint name to match your ApiEndPoints class,
  //     //   e.g. ApiEndPoints.checkoutSubscription -> '/author/subscription/checkout'
  //
  //     final response = await http.post(
  //       uri,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode({
  //         'planId': planId,
  //       }),
  //     );
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final responseBody = jsonDecode(response.body);
  //       if (responseBody is! Map<String, dynamic>) {
  //         Utils.showToast('Server returned invalid JSON response', true);
  //         throw Exception('Invalid JSON response');
  //       }
  //
  //       final String? clientSecret = responseBody['clientSecret']?.toString();
  //       if (clientSecret == null || clientSecret.isEmpty) {
  //         Utils.showToast('Client secret missing in response', true);
  //         throw Exception('Client secret missing');
  //       }
  //
  //       return clientSecret;
  //     } else {
  //       Utils.showToast('Error: ${response.statusCode}', true);
  //       throw Exception('Failed to create payment intent: ${response.body}');
  //     }
  //   } catch (e) {
  //     Utils.showToast('Error: $e', true);
  //     rethrow;
  //   }
  // }
  //
  // Future<void> confirmSubscriptionPayment(String paymentIntentId) async {
  //   try {
  //     final token = SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
  //     if (token.isEmpty) {
  //       Utils.showToast('Please login again', true);
  //       throw Exception('No auth token found');
  //     }
  //
  //     final uri = Uri.parse('${BaseService().baseURL}${ApiEndPoints.confirmSubscriptionPayment}');
  //     // e.g. '/author/subscription/confirm-payment'
  //
  //     final response = await http.post(
  //       uri,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode({'paymentIntentId': paymentIntentId}),
  //     );
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       Utils.showToast('Subscription activated successfully', false);
  //     } else {
  //       Utils.showToast('Error: ${response.statusCode}', true);
  //       throw Exception('Failed to confirm subscription payment: ${response.body}');
  //     }
  //   } catch (e) {
  //     Utils.showToast('Error: $e', true);
  //     rethrow;
  //   }
  // }


  // No payment logic in this controller. Stripe payment is handled by StripePaymentController.

  // Toggle function
  void setYearly(bool value) {
    isYearly.value = value;
    // Toggle hone par naya data fetch karein
    fetchSubscriptionPlans(value ? 'yearly' : 'monthly');
  }

  // API Call
  Future<void> fetchSubscriptionPlans(String planType) async {
    try {
      isLoading.value = true;
      plans.clear();
      
      final token = SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
      
      if (token.isEmpty) {
        Utils.showToast('Token not found. Please login again', true);
        isLoading.value = false;
        return;
      }

      final baseUrl = '${BaseService().baseURL}${ApiEndPoints.planType}';
      final Map<String, String> queryParams = {'planType': planType};
      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

      print('🔍 DEBUG: API URL: $uri');
      print('🔍 DEBUG: Plan Type: $planType');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('🔍 DEBUG: Status Code: ${response.statusCode}');
      print('🔍 DEBUG: Response Body: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print('🔍 DEBUG: Response Type: ${responseBody.runtimeType}');

        List<dynamic> plansList = [];

        // Handle different response formats
        if (responseBody is List) {
          plansList = responseBody;
          print('🔍 DEBUG: Response is a List');
        } else if (responseBody is Map) {
          if (responseBody['data'] != null && responseBody['data'] is List) {
            plansList = responseBody['data'];
            print('🔍 DEBUG: Response has "data" field with list');
          } else if (responseBody['plans'] != null && responseBody['plans'] is List) {
            plansList = responseBody['plans'];
            print('🔍 DEBUG: Response has "plans" field with list');
          } else {
            print('⚠️ DEBUG: Unexpected response format. Keys: ${responseBody.keys}');
            return;
          }
        }

        print('🔍 DEBUG: Items count: ${plansList.length}');
        print('🔍 DEBUG: First item type: ${plansList.isNotEmpty ? plansList[0].runtimeType : 'N/A'}');
        print('🔍 DEBUG: First item: ${plansList.isNotEmpty ? plansList[0] : 'N/A'}');

        if (plansList.isNotEmpty) {
          final parsedPlans = <SubscriptionPlan>[];
          
          for (var item in plansList) {
            try {
              if (item is Map<String, dynamic>) {
                final plan = SubscriptionPlan.fromJson(item);
                parsedPlans.add(plan);
              } else {
                print('⚠️ DEBUG: Item is not a Map, it\'s ${item.runtimeType}');
              }
            } catch (e) {
              print('❌ DEBUG: Error parsing item: $e');
              print('❌ DEBUG: Item data: $item');
            }
          }

          if (parsedPlans.isNotEmpty) {
            plans.assignAll(parsedPlans);
            print('✅ DEBUG: Successfully parsed ${plans.length} plans');
          } else {
            Utils.showToast('Could not parse plans from response', true);
          }
        } else {
          Utils.showToast('No subscription plans available', false);
        }
      } else {
        try {
          final errorBody = jsonDecode(response.body);
          final errorMsg = errorBody['message'] ?? 'Failed to load plans';
          Utils.showToast('$errorMsg (${response.statusCode})', true);
          print('❌ DEBUG: Error - $errorMsg');
        } catch (_) {
          Utils.showToast('Failed to load plans: ${response.statusCode}', true);
        }
      }
    } catch (e) {
      print('❌ DEBUG: Exception: $e');
      Utils.showToast('Error: $e', true);
    } finally {
      isLoading.value = false;
    }
  }

  void selectPlan(SubscriptionPlan plan) {
    selectedPlan.value = plan;
    Get.toNamed('/selectplan');
  }
}