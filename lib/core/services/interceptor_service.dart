import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../constants/local_db_key.dart';
import '../../utils/shared_prefrences_methods.dart';
import '../../utils/utility.dart';

class ApiInterceptor extends http.BaseClient {
  final http.Client _inner;
  final prefs = SharedPreferencesMethod.storage;
  final String baseURL = "https://mockup.testdevlink.com/story-sign-backend/api/v1";
  static const String refreshTokenEndpoint = '/auth/refresh'; // 👈 your endpoint

  Future<bool>? _refreshFuture;

  ApiInterceptor({http.Client? inner}) : _inner = inner ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await _sendWithAuth(request);

    // ---------- AUTO REFRESH ON 401 ----------
    if (response.statusCode == 401) {
      final refreshed = await _refreshToken();
      if (refreshed) {

        final retryRequest = _cloneRequest(request);
        final retryResponse = await _sendWithAuth(retryRequest, isStreamed: true);
        return http.StreamedResponse(
          Stream.value(retryResponse.bodyBytes),
          retryResponse.statusCode,
          headers: retryResponse.headers,
          request: retryRequest,
        );
      } else {
        // refresh failed → force logout / clear session here if needed
        Utils.showToast("Session expired, please login again", true);
      }
    }

    if (response.statusCode >= 400) {
      _handleError(response);
    }

    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      headers: response.headers,
      request: request,
    );
  }

  Future<http.Response> _sendWithAuth(http.BaseRequest request, {bool isStreamed = false}) async {
    final bearerToken = await prefs.getString(LocalDBKeys.TOKEN);
    request.headers['Content-Type'] = 'application/json; charset=UTF-8';
    request.headers['Authorization'] = 'Bearer $bearerToken';

    print("➡️ [${request.method}] ${request.url}");

    try {
      final streamedResponse =
      await _inner.send(request).timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamedResponse);

      print("⬅️ [${response.statusCode}] ${request.url}");
      print("Response: ${response.body}");

      return response;
    } on TimeoutException {
      Utils.showToast("Request timed out", true);
      rethrow;
    } catch (e) {
      Utils.showToast("Unexpected error", true);
      rethrow;
    }
  }

  /// Calls the refresh endpoint, saves new token, returns true on success.
  /// Deduplicates concurrent refresh calls via _refreshFuture.
  Future<bool> _refreshToken() {
    _refreshFuture ??= _doRefresh().whenComplete(() => _refreshFuture = null);
    return _refreshFuture!;
  }

  Future<bool> _doRefresh() async {
    try {
      final savedRefreshToken = await prefs.getString(LocalDBKeys.REFRESH_TOKEN)
          ?? await prefs.getString(LocalDBKeys.TOKEN); // fallback to access token if no refresh token saved yet

      final response = await _inner.post(
        Uri.parse("$baseURL$refreshTokenEndpoint"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({"refreshToken": savedRefreshToken}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = json.decode(response.body);
        final newToken = jsonData["token"] ?? jsonData["accessToken"];
        final newRefreshToken = jsonData["refreshToken"];

        if (newToken != null) {
          await prefs.setString(LocalDBKeys.TOKEN, newToken);
        }
        if (newRefreshToken != null) {
          // Save refresh token separately — do NOT overwrite the access token
          await prefs.setString(LocalDBKeys.REFRESH_TOKEN, newRefreshToken);
        }
        return newToken != null;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// http requests can't be resent as-is (body stream is consumed),
  /// so clone the request before retrying.
  http.BaseRequest _cloneRequest(http.BaseRequest original) {
    if (original is http.Request) {
      final cloned = http.Request(original.method, original.url)
        ..headers.addAll(original.headers)
        ..body = original.body;
      return cloned;
    }
    // extend here if you use MultipartRequest etc.
    return original;
  }

  void _handleError(http.Response response) {
    if (response.body.isEmpty) return;
    try {
      final jsonData = json.decode(response.body);
      final message = jsonData is Map ? jsonData["message"] : null;
      Utils.showToast(
        message is List ? message.join(', ') : (message?.toString() ?? "Something went wrong"),
        true,
      );
    } catch (_) {}
  }
}