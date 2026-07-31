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
      print('🔁 Received 401, attempting token refresh...');
      final refreshed = await _refreshToken();
      print('🔁 Refresh result: $refreshed');
      if (refreshed) {
        final retryRequest = _cloneRequest(request);
        try {
          final retryResponse = await _sendWithAuth(retryRequest, isStreamed: true);
          return http.StreamedResponse(
            Stream.value(retryResponse.bodyBytes),
            retryResponse.statusCode,
            headers: retryResponse.headers,
            request: retryRequest,
          );
        } catch (e) {
          // If retry fails, return original 401 response instead of crashing
          return http.StreamedResponse(
            Stream.value(response.bodyBytes),
            response.statusCode,
            headers: response.headers,
            request: request,
          );
        }
      } else {
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
    
    if (request is! http.MultipartRequest) {
      request.headers['Content-Type'] = 'application/json; charset=UTF-8';
    }
  
    if (bearerToken != null && bearerToken.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $bearerToken';
    } else {
      request.headers.remove('Authorization');
    }

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
      // Use only the refresh token for refresh calls. Do NOT fall back to access token.
      final savedRefreshToken = await prefs.getString(LocalDBKeys.REFRESH_TOKEN);
      if (savedRefreshToken == null || savedRefreshToken.isEmpty) {
        print('🔁 No refresh token available');
        return false;
      }

      print('🔁 Refreshing session using stored refresh token...');
      final response = await _inner.post(
        Uri.parse("$baseURL$refreshTokenEndpoint"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({"refreshToken": savedRefreshToken}),
      ).timeout(const Duration(seconds: 30));

      print('🔁 Refresh response status: ${response.statusCode}');
      print('🔁 Refresh response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = json.decode(response.body);

        String? newToken;
        String? newRefreshToken;

        if (jsonData is Map) {
          // Some APIs wrap payload under `data`
          if (jsonData.containsKey('data') && jsonData['data'] is Map) {
            final d = jsonData['data'] as Map<String, dynamic>;
            newToken = d['token'] ?? d['accessToken'] ?? d['access_token'];
            newRefreshToken = d['refreshToken'] ?? d['refresh_token'];
          }
          newToken ??= jsonData['token'] ?? jsonData['accessToken'] ?? jsonData['access_token'];
          newRefreshToken ??= jsonData['refreshToken'] ?? jsonData['refresh_token'];
        }

        if (newToken != null && newToken.isNotEmpty) {
          await prefs.setString(LocalDBKeys.TOKEN, newToken);
        }
        if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
          // Save refresh token separately — do NOT overwrite the access token
          await prefs.setString(LocalDBKeys.REFRESH_TOKEN, newRefreshToken);
        }
        return newToken != null && newToken.isNotEmpty;
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
    } else if (original is http.MultipartRequest) {
      final cloned = http.MultipartRequest(original.method, original.url)
        ..headers.addAll(original.headers)
        ..fields.addAll(original.fields);
      for (final file in original.files) {
        cloned.files.add(file);
      }
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