import 'package:get/get.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/utility.dart';
import '../model/subscription_model.dart';

class SubscriptionPlanController extends GetxController {
  // Observables
  var isYearly = false.obs;
  var isLoading = false.obs;
  var plans = <SubscriptionPlan>[].obs;
  var selectedPlan = Rx<SubscriptionPlan?>(null);

  @override
  void onInit() {
    super.onInit();
    // Default load monthly
    fetchSubscriptionPlans('monthly');
  }

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
      
      final endpoint = '${ApiEndPoints.planType}?planType=$planType';
      
      print('🔍 DEBUG: Fetching Plans for: $planType');

      final response = await BaseService().baseGetAPI(
        endpoint,
        loading: false,
      );

      if (response['success'] == true) {
        List<dynamic> plansList = [];

        if (response['data'] != null && response['data'] is List) {
          plansList = response['data'];
        } else if (response['plans'] != null && response['plans'] is List) {
          plansList = response['plans'];
        } else if (response.keys.any((k) => k != 'success' && k != 'statusCode' && response[k] is List)) {
           // Fallback if data is inside another key
           final key = response.keys.firstWhere((k) => k != 'success' && k != 'statusCode' && response[k] is List);
           plansList = response[key];
        }

        if (plansList.isNotEmpty) {
          final parsedPlans = <SubscriptionPlan>[];
          
          for (var item in plansList) {
            try {
              if (item is Map<String, dynamic>) {
                final plan = SubscriptionPlan.fromJson(item);
                parsedPlans.add(plan);
              }
            } catch (e) {
              print('❌ DEBUG: Error parsing item: $e');
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
        Utils.showToast(response['message'] ?? 'Failed to load plans', true);
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