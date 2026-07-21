import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';
import '../../home/model/home_model.dart';

import 'package:http/http.dart' as http;
class RequestDetailController extends GetxController{

  // .obs variable
  var sourceScreen = ''.obs;
  RxString errorMessage = ''.obs;
  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      sourceScreen.value = Get.arguments['from'] ?? '';
      print("SOURCE SCREEN IS: ${sourceScreen.value}");
    }
  }

  // Getter mein .value lagayein
  bool get isFromDelivered => sourceScreen.value == 'all_delivered';

  // Single Autograph Request Details fetch karne ke liye Rxn variable
  Rxn<AutographItemModel> selectedRequestDetail = Rxn<AutographItemModel>();
  var isFetchDetailLoading = false.obs;

  Future<void> fetchAutographRequestDetails(String autographRequestId) async {
    try {
      isFetchDetailLoading.value = true;
      errorMessage.value = '';

      final prefs = SharedPreferencesMethod.storage;
      final String token = prefs.getString(LocalDBKeys.TOKEN) ?? '';

      if (token.isEmpty) {
        errorMessage.value = 'Token not found';
        Utils.showToast('Please login again', true);
        return;
      }

      // Dynamic endpoint function use karte hue URL banayein
      final uri = Uri.parse(
        '${BaseService().baseURL}${ApiEndPoints.autographRequestDetails(autographRequestId)}',
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = jsonDecode(response.body);

        // Agar API direct single object bhej rahi hai ya 'data' key ke andar bhej rahi hai
        final itemJson = responseBody is Map && responseBody.containsKey('data')
            ? responseBody['data']
            : responseBody;

        selectedRequestDetail.value = AutographItemModel.fromJson(itemJson);

      } else {
        final responseBody = jsonDecode(response.body);
        errorMessage.value =
            responseBody['message']?.toString() ?? 'Failed to load request details';
        Utils.showToast(errorMessage.value, true);
      }
    } catch (e) {
      debugPrint('Error: $e');
      errorMessage.value = 'Something went wrong while loading details';
      Utils.showToast(errorMessage.value, true);
    } finally {
      isFetchDetailLoading.value = false;
      EasyLoading.dismiss();
    }
  }
}