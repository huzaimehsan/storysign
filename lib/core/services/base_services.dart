import 'dart:async';

import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../constants/local_db_key.dart';
import '../../utils/shared_prefrences_methods.dart';
import '../../utils/utility.dart';
import 'interceptor_service.dart';

class BaseService {
  late String baseURL =
      "https://mockup.testdevlink.com/story-sign-backend/api/v1";
  // late String baseURL = "http://192.168.83.183:8000/love-on-life";
  late String endPoint;
  late String Url = '$baseURL$endPoint';
  late String baseURLStripe = "";
  late String baseS3URL = "";
  final prefs = SharedPreferencesMethod.storage;

  // 👇 All HTTP calls now go through ApiInterceptor for auto token refresh
  final http.Client _client = ApiInterceptor();

  String? token = '';
  String? stripeToken;

  String _parseMessage(
      dynamic message, {
        String defaultMessage = "Something went wrong",
      }) {
    if (message is List) {
      return message.join(', ');
    }
    return message?.toString() ?? defaultMessage;
  }

  Future<bool> checkInternetConnection() async {
    bool result = await InternetConnectionChecker.instance.hasConnection;
    return result;
  }

  Future<Map<String, dynamic>> basePostAPI(
      String endPoint,
      dynamic body, {
        bool loading = true,
        bool? isStripe,
      }) async {
    if (loading) {
      EasyLoading.show(
        status: 'Please wait...',
        maskType: EasyLoadingMaskType.black,
      );
    }

    if (!await checkInternetConnection()) {
      EasyLoading.dismiss();
      return {'success': false, 'message': 'Check Internet Connection'};
    }

    try {
      // Token injection & 401 refresh handled by ApiInterceptor
      final response = await _client
          .post(
        Uri.parse(isStripe == true ? baseURLStripe : "$baseURL$endPoint"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 60));

      EasyLoading.dismiss();

      print("URL: $baseURL$endPoint");
      print("Status: ${response.statusCode}");
      print("Response: ${response.body}");

      // SUCCESS (NO TOAST HERE!)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonData = json.decode(response.body);

        if (jsonData is List) {
          return {
            "success": true,
            "data": jsonData, // List ko 'data' key mein dal diya
            "statusCode": response.statusCode,
          };
        }

        // Agar response pehle se hi Map hai
        return {
          "success": true,
          ...jsonData,
          "statusCode": response.statusCode,
        };
      }

      // ERROR
      if (response.body.isNotEmpty) {
        var jsonData = json.decode(response.body);

        Utils.showToast(_parseMessage(jsonData["message"]), true);

        return {
          "success": false,
          "message": jsonData["message"] ?? "Something went wrong",
          "statusCode": response.statusCode,
        };
      }

      Utils.showToast("Something went wrong", true);
      return {"success": false};
    } on TimeoutException {
      EasyLoading.dismiss();
      Utils.showToast("Request timed out", true);
      return {"success": false};
    } catch (e) {
      EasyLoading.dismiss();
      Utils.showToast("Unexpected error", true);
      return {"success": false};
    }
  }

  Future<Map<String, dynamic>> baseGetAPI(
      String endPoint, {
        bool loading = true,
        bool? isStripe,
        bool showErrorToast = true,
      }) async {
    if (loading) {
      // NOTE: Original code had EasyLoading commented out here. Keeping it that way.
      EasyLoading.show(
        status: 'Please wait...',
        maskType: EasyLoadingMaskType.black,
      );
    }

    if (!await checkInternetConnection()) {
      EasyLoading.dismiss();
      Utils.showToast("Check Internet Connection", true);
      return {'success': false, 'message': 'Check Internet Connection'};
    }

    try {
      final response = await _client
          .get(
        Uri.parse(isStripe == true ? baseURLStripe : "$baseURL$endPoint"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      )
          .timeout(const Duration(seconds: 60));

      EasyLoading.dismiss();

      print("GET URL: $baseURL$endPoint");
      print("Status: ${response.statusCode}");
      print("Response: ${response.body}");

      // ---------- SUCCESS ----------
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonData = json.decode(response.body);
        if (jsonData is List) {
          return {
            "success": true,
            "data": jsonData,
            "statusCode": response.statusCode,
          };
        }
        // Agar JSON Map hai
        return {
          "success": true,
          ...jsonData,
          "statusCode": response.statusCode,
        };
      }
      // ---------- ERROR ----------
      if (response.body.isNotEmpty) {
        var jsonData = json.decode(response.body);
        if (showErrorToast) {
          Utils.showToast(_parseMessage(jsonData["message"]), true);
        }
        return {
          "success": false,
          "message": jsonData["message"] ?? "Something went wrong",
          "statusCode": response.statusCode,
        };
      }

      if (showErrorToast) {
        Utils.showToast("Something went wrong", true);
      }
      return {"success": false, "message": "Something went wrong"};
    } on TimeoutException {
      EasyLoading.dismiss();
      Utils.showToast("Request timed out", true);
      return {"success": false, "message": "Request timed out"};
    } catch (e) {
      EasyLoading.dismiss();
      Utils.showToast("Unexpected error", true);
      return {"success": false, "message": "Unexpected error"};
    }
  }

  Future<Map<String, dynamic>> basePutAPI(
      String endPoint, {
        required Map<String, dynamic> body,
        bool loading = true,
        bool? isStripe,
      }) async {
    if (loading) {
      EasyLoading.show(
        status: 'Please wait...',
        maskType: EasyLoadingMaskType.black,
      );
    }

    if (!await checkInternetConnection()) {
      EasyLoading.dismiss();
      Utils.showToast("Check Internet Connection", true);
      return {'success': false, 'message': 'Check Internet Connection'};
    }

    try {
      final response = await _client
          .put(
        Uri.parse(isStripe == true ? baseURLStripe : "$baseURL$endPoint"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(body),
      )
          .timeout(const Duration(seconds: 60));

      EasyLoading.dismiss();

      print("PUT URL: $baseURL$endPoint");
      print("Body: $body");
      print("Status: ${response.statusCode}");
      print("Response: ${response.body}");

      // ---------- SUCCESS ----------
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonData = json.decode(response.body);
        return {
          "success": true,
          ...jsonData,
          "statusCode": response.statusCode,
        };
      }

      // ---------- ERROR ----------
      if (response.body.isNotEmpty) {
        var jsonData = json.decode(response.body);
        Utils.showToast(_parseMessage(jsonData["message"]), true);
        return {
          "success": false,
          "message": jsonData["message"] ?? "Something went wrong",
          "statusCode": response.statusCode,
        };
      }

      Utils.showToast("Something went wrong", true);
      return {"success": false, "message": "Something went wrong"};
    } on TimeoutException {
      EasyLoading.dismiss();
      Utils.showToast("Request timed out", true);
      return {"success": false, "message": "Request timed out"};
    } catch (e) {
      EasyLoading.dismiss();
      Utils.showToast("Unexpected error", true);
      return {"success": false, "message": "Unexpected error"};
    }
  }

  Future<Map<String, dynamic>> basePatchAPI(
      String endPoint, {
        required Map<String, dynamic> body,
        bool loading = true,
        bool? isStripe,
      }) async {
    if (loading) {
      EasyLoading.show(
        status: 'Please wait...',
        maskType: EasyLoadingMaskType.black,
      );
    }

    if (!await checkInternetConnection()) {
      EasyLoading.dismiss();
      Utils.showToast("Check Internet Connection", true);
      return {'success': false, 'message': 'Check Internet Connection'};
    }

    try {
      final response = await _client
          .patch(
        Uri.parse(isStripe == true ? baseURLStripe : "$baseURL$endPoint"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(body),
      )
          .timeout(const Duration(seconds: 60));

      EasyLoading.dismiss();

      print("PATCH URL: $baseURL$endPoint");
      print("Body: $body");
      print("Status: ${response.statusCode}");
      print("Response: ${response.body}");

      // ---------- SUCCESS ----------
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonData = json.decode(response.body);
        return {
          "success": true,
          ...jsonData,
          "statusCode": response.statusCode,
        };
      }

      // ---------- ERROR ----------
      if (response.body.isNotEmpty) {
        var jsonData = json.decode(response.body);
        Utils.showToast(_parseMessage(jsonData["message"]), true);
        return {
          "success": false,
          "message": jsonData["message"] ?? "Something went wrong",
          "statusCode": response.statusCode,
        };
      }

      Utils.showToast("Something went wrong", true);
      return {"success": false, "message": "Something went wrong"};
    } on TimeoutException {
      EasyLoading.dismiss();
      Utils.showToast("Request timed out", true);
      return {"success": false, "message": "Request timed out"};
    } catch (e) {
      EasyLoading.dismiss();
      Utils.showToast("Unexpected error", true);
      return {"success": false, "message": "Unexpected error"};
    }
  }

  Future<http.MultipartRequest> buildMultipartRequest(
      String endPoint, {
        String method = 'POST',
        bool? isStripe,
        Map<String, String>? headers,
      }) async {
    final request = http.MultipartRequest(
      method,
      Uri.parse(isStripe == true ? baseURLStripe : '$baseURL$endPoint'),
    );

    final token = await prefs.getString(LocalDBKeys.TOKEN);
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    if (headers != null) {
      request.headers.addAll(headers);
    }

    return request;
  }

  Future<Map<String, dynamic>> baseMultipartPostAPI(
      String endPoint, {
        required http.MultipartRequest request,
        bool loading = true,
        bool? isStripe,
      }) async {
    if (loading) {
      EasyLoading.show(
        status: 'Please wait...',
        maskType: EasyLoadingMaskType.black,
      );
    }

    if (!await checkInternetConnection()) {
      EasyLoading.dismiss();
      Utils.showToast("Check Internet Connection", true);
      return {'success': false, 'message': 'Check Internet Connection'};
    }

    try {
      final token = await prefs.getString(LocalDBKeys.TOKEN);
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      final streamedResponse = await _client.send(request).timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamedResponse);

      EasyLoading.dismiss();

      print("MULTIPART POST URL: $baseURL$endPoint");
      print("Status: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final dynamic jsonData = json.decode(response.body);
        if (jsonData is Map<String, dynamic>) {
          return {
            'success': true,
            ...jsonData,
            'statusCode': response.statusCode,
          };
        }
        return {'success': true, 'data': jsonData, 'statusCode': response.statusCode};
      }

      if (response.body.isNotEmpty) {
        try {
          final jsonData = json.decode(response.body);
          final message = jsonData is Map ? jsonData['message'] : null;
          Utils.showToast(_parseMessage(message), true);
          return {
            'success': false,
            'message': message ?? 'Something went wrong',
            'statusCode': response.statusCode,
          };
        } catch (_) {
          Utils.showToast('Something went wrong', true);
          return {'success': false, 'message': 'Something went wrong', 'statusCode': response.statusCode};
        }
      }

      Utils.showToast('Something went wrong', true);
      return {'success': false, 'message': 'Something went wrong'};
    } on TimeoutException {
      EasyLoading.dismiss();
      Utils.showToast('Request timed out', true);
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      EasyLoading.dismiss();
      Utils.showToast('Unexpected error', true);
      return {'success': false, 'message': 'Unexpected error'};
    }
  }

  Future<Map<String, dynamic>> baseMultipartPatchAPI(
      String endPoint, {
        required http.MultipartRequest request,
        bool loading = true,
        bool? isStripe,
      }) async {
    if (loading) {
      EasyLoading.show(
        status: 'Please wait...',
        maskType: EasyLoadingMaskType.black,
      );
    }

    if (!await checkInternetConnection()) {
      EasyLoading.dismiss();
      Utils.showToast("Check Internet Connection", true);
      return {'success': false, 'message': 'Check Internet Connection'};
    }

    try {
      final token = await prefs.getString(LocalDBKeys.TOKEN);
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      final streamedResponse = await _client.send(request).timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamedResponse);

      EasyLoading.dismiss();

      print("MULTIPART PATCH URL: $baseURL$endPoint");
      print("Status: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final dynamic jsonData = json.decode(response.body);
        if (jsonData is Map<String, dynamic>) {
          return {
            'success': true,
            ...jsonData,
            'statusCode': response.statusCode,
          };
        }
        return {'success': true, 'data': jsonData, 'statusCode': response.statusCode};
      }

      if (response.body.isNotEmpty) {
        try {
          final jsonData = json.decode(response.body);
          final message = jsonData is Map ? jsonData['message'] : null;
          Utils.showToast(_parseMessage(message), true);
          return {
            'success': false,
            'message': message ?? 'Something went wrong',
            'statusCode': response.statusCode,
          };
        } catch (_) {
          Utils.showToast('Something went wrong', true);
          return {'success': false, 'message': 'Something went wrong', 'statusCode': response.statusCode};
        }
      }

      Utils.showToast('Something went wrong', true);
      return {'success': false, 'message': 'Something went wrong'};
    } on TimeoutException {
      EasyLoading.dismiss();
      Utils.showToast('Request timed out', true);
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      EasyLoading.dismiss();
      Utils.showToast('Unexpected error', true);
      return {'success': false, 'message': 'Unexpected error'};
    }
  }

  // 💡 NEW FUNCTION: baseDeleteAPI
  Future<Map<String, dynamic>> baseDeleteAPI(
      String endPoint, {
        bool loading = true,
        bool? isStripe,
      }) async {
    if (loading) {
      EasyLoading.show(
        status: 'Please wait...',
        maskType: EasyLoadingMaskType.black,
      );
    }

    if (!await checkInternetConnection()) {
      EasyLoading.dismiss();
      Utils.showToast("Check Internet Connection", true);
      return {'success': false, 'message': 'Check Internet Connection'};
    }

    try {
      final response = await _client
          .delete(
        Uri.parse(isStripe == true ? baseURLStripe : "$baseURL$endPoint"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      )
          .timeout(const Duration(seconds: 60));

      EasyLoading.dismiss();

      print("DELETE URL: $baseURL$endPoint");
      print("Status: ${response.statusCode}");
      print("Response: ${response.body}");

      // ---------- SUCCESS (Typically 200 or 204 No Content for DELETE) ----------
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Handle 204 No Content gracefully (response.body might be empty)
        if (response.body.isEmpty || response.statusCode == 204) {
          Utils.showToast("Deleted successfully", false);
          return {
            "success": true,
            "message": "Deleted successfully",
            "statusCode": response.statusCode,
          };
        }

        var jsonData = json.decode(response.body);
        Utils.showToast(
          _parseMessage(
            jsonData["message"],
            defaultMessage: "Deleted successfully",
          ),
          false,
        );
        return {
          "success": true,
          ...jsonData,
          "statusCode": response.statusCode,
        };
      }

      // ---------- ERROR ----------
      if (response.body.isNotEmpty) {
        var jsonData = json.decode(response.body);
        Utils.showToast(
          _parseMessage(jsonData["message"], defaultMessage: "Deletion failed"),
          true,
        );
        return {
          "success": false,
          "message": jsonData["message"] ?? "Deletion failed",
          "statusCode": response.statusCode,
        };
      }

      Utils.showToast("Something went wrong during deletion", true);
      return {
        "success": false,
        "message": "Something went wrong during deletion",
      };
    } on TimeoutException {
      EasyLoading.dismiss();
      Utils.showToast("Request timed out", true);
      return {"success": false, "message": "Request timed out"};
    } catch (e) {
      EasyLoading.dismiss();
      Utils.showToast("Unexpected error", true);
      return {"success": false, "message": "Unexpected error"};
    }
  }
}