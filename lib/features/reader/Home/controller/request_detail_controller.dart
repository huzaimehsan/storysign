import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';
import '../model/home_model.dart';

class AuthorDetailController extends GetxController {
  String? autographRequestId;

  RxBool isloading = false.obs;
  RxString errorMessage = ''.obs;
  Rxn<BookItem> selectedRequest = Rxn<BookItem>();

  void onInit() {
    super.onInit();

   authorDetail(autographRequestId);
  }


  void setRequestId(String? id) {
    final normalizedId = id?.trim();
    debugPrint('RequestDetailController setRequestId: $normalizedId');
    if ((autographRequestId ?? '') == normalizedId) return;

    autographRequestId = normalizedId;
    if ((normalizedId ?? '').isNotEmpty) {
      authorDetail(normalizedId);
    } else {
      selectedRequest.value = null;
    }
  }

  Future<void> authorDetail(String? requestId) async {
    final normalizedId = requestId?.trim();
    if ((normalizedId ?? '').isEmpty) {
      errorMessage.value = 'Request id not found';
      Utils.showToast('Request not found', true);
      return;
    }

    try {
      isloading.value = true;
      errorMessage.value = '';

      final prefs = SharedPreferencesMethod.storage;
      final token = prefs.getString(LocalDBKeys.TOKEN) ?? '';

      if (token.isEmpty) {
        errorMessage.value = 'Token not found';
        Utils.showToast('Please login again', true);
        return;
      }

      final endpoint = ApiEndPoints.getAutographRequestDetails(normalizedId!);
      debugPrint('RequestDetailController fetching: ${BaseService().baseURL}$endpoint');
      final uri = Uri.parse('${BaseService().baseURL}$endpoint');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('RequestDetailController response body: ${response.body}');
        final decodedBody = jsonDecode(response.body);
        final parsedRequest = BookItem.fromResponse(decodedBody);

        if (parsedRequest != null) {
          debugPrint('RequestDetailController parsed request: ${parsedRequest.title}');
          selectedRequest.value = parsedRequest;
        } else {
          errorMessage.value = 'Unexpected response format';
          Utils.showToast(errorMessage.value, true);
        }
      } else {
        errorMessage.value = 'Failed to load details';
        Utils.showToast(errorMessage.value, true);
      }
    } catch (e) {
      debugPrint('Error: $e');
      errorMessage.value = 'Something went wrong';
      Utils.showToast(errorMessage.value, true);
    } finally {
      isloading.value = false;
      EasyLoading.dismiss();
    }
  }
}


