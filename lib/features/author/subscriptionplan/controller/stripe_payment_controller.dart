// Existing imports ke sath ye bhi add karein
import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:storysign/features/author/subscriptionplan/controller/subscription_plan_controller.dart';

import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/utility.dart';
class StripePaymentController extends GetxController {
  // ... aapke existing variables (selectedPlan, etc.)


}