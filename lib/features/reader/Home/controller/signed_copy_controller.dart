import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:storysign/features/reader/Home/model/home_model.dart';

import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';

class SignedCopyController extends GetxController {
  String? autographRequestId;
  String? bookId;

  RxBool isloading = false.obs;
  RxString errorMessage = ''.obs;
  Rxn<NewBookItem> selectedRequest = Rxn<NewBookItem>();

  @override
  @override
  void onInit() {
    super.onInit();

    var args = Get.arguments;
    debugPrint('Received Arguments: $args');

    if (args != null && args is Map) {
      // 💡 Sabse pehle 'autographRequestId' ko check karein kyunki API ko wahi chahiye
      autographRequestId =
          args['autographRequestId']?.toString() ??
              args['requestId']?.toString() ??
              '';
      bookId = args['bookId']?.toString() ?? args['bookIdValue']?.toString() ?? '';

      debugPrint('Extracted autographRequestId -> $autographRequestId');
      debugPrint('Extracted bookId -> $bookId');

      if (autographRequestId != null && autographRequestId!.isNotEmpty) {
        bookDetailCopy(autographRequestId);
      } else if (bookId != null && bookId!.isNotEmpty) {
        debugPrint('No autographRequestId provided; using bookId for download only');
      } else {
        errorMessage.value = 'Request id not found';
        Utils.showToast('Request ID missing in arguments', true);
      }
    } else {
      errorMessage.value = 'Arguments not found';
      Utils.showToast('No arguments passed to screen', true);
    }
  }

  Future<void> bookDetailCopy(String? requestId) async {
    final normalizedId = requestId?.trim();
    if (normalizedId == null || normalizedId.isEmpty) {
      errorMessage.value = 'Request id not found';
      return;
    }

    try {
      isloading.value = true;

      final endpoint = ApiEndPoints.getAutographRequestDetails(normalizedId);
      final response = await BaseService().baseGetAPI(endpoint, loading: false);

      if (response['success'] == true) {
        final parsedRequest = NewBookItem.fromResponse(response);

        if (parsedRequest != null) {
          selectedRequest.value = parsedRequest;
        } else {
          throw Exception('Failed to parse data');
        }
      } else {
        throw Exception(response['message']?.toString() ?? 'Server Error');
      }
    } catch (e) {
      debugPrint('Error: $e');
      errorMessage.value = 'Something went wrong';
      if (e.toString().contains('Failed to parse data')) {
        Utils.showToast(errorMessage.value, true);
      }
    } finally {
      isloading.value = false;
    }
  }

  Future<void> downloadBook(String? selectedPathId, String? fileName) async {
    final String? resolvedBookId =
        (selectedRequest.value?.bookId?.trim().isNotEmpty == true)
            ? selectedRequest.value!.bookId
            : (selectedPathId?.trim().isNotEmpty == true
                ? selectedPathId!.trim()
                : null);

    final String? resolvedAutographRequestId =
        (autographRequestId?.trim().isNotEmpty == true)
            ? autographRequestId!.trim()
            : (selectedRequest.value?.autographRequestId?.trim().isNotEmpty == true
                ? selectedRequest.value!.autographRequestId.trim()
                : null);

    if (resolvedBookId == null || resolvedBookId.isEmpty) {
      Utils.showToast('Unable to download book: book ID missing', true);
      return;
    }

    if (resolvedAutographRequestId == null || resolvedAutographRequestId.isEmpty) {
      Utils.showToast(
          'Unable to download book: autograph request ID missing', true);
      return;
    }

    try {
      EasyLoading.show(
        status: 'Downloading...',
        maskType: EasyLoadingMaskType.black,
      );

      final token =
          SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
      debugPrint('Download: token present=${token.isNotEmpty}, length=${token.length}');
      if (token.isEmpty) {
        Utils.showToast('Please login again', true);
        return;
      }

      final uri = Uri.parse(
        '${BaseService().baseURL}${ApiEndPoints.downloadBook(resolvedBookId)}',
      );

      // 1. POST request to get JSON containing the file URL/path
      debugPrint('Download POST URI: $uri');
      debugPrint('Download POST bookId: $resolvedBookId');
      final requestBody = {'autographRequestId': resolvedAutographRequestId};
      debugPrint('Download POST body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint('Download POST status: ${response.statusCode}');
      debugPrint('Download POST headers: ${response.headers}');
      debugPrint('Download POST response body: ${response.body}');

      if (response.statusCode == 401) {
        Utils.showToast('Session expired. Please login again.', true);
        try {
          await SharedPreferencesMethod.storage.clear();
        } catch (_) {}
        Get.offAllNamed('/signin');
        return;
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final contentType =
            response.headers['content-type']?.toLowerCase() ?? '';

        if ((response.body ?? '').trim().isEmpty) {
          debugPrint('Empty response body for download POST to $uri — trying GET fallback');

       
          try {
            final getResp = await http.get(
              uri,
              headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
            );
            debugPrint('GET fallback status: ${getResp.statusCode}');
            debugPrint('GET fallback headers: ${getResp.headers}');
            debugPrint('GET fallback body: ${getResp.body}');

            if ((getResp.body ?? '').trim().isEmpty) {
              Utils.showToast('Server returned empty response for download', true);
              return;
            }

            final fallbackBody = _tryDecodeJson(getResp.body);
            if (fallbackBody is Map<String, dynamic>) {
         
              String? downloadUrl = fallbackBody['downloadUrl']?.toString();
              if (downloadUrl == null || downloadUrl.isEmpty) {
                final String? filePath = fallbackBody['downloadedFilePath']?.toString();
                if (filePath == null || filePath.isEmpty) {
                  Utils.showToast('Download path is missing in response', true);
                  return;
                }

                final String domain = BaseService().baseURL.replaceAll('/api/v1', '');
                if (filePath.startsWith('http')) {
                  downloadUrl = filePath;
                } else if (filePath.startsWith('/')) {
                  downloadUrl = '$domain$filePath';
                } else {
                  downloadUrl = '$domain/$filePath';
                }
              }

              debugPrint('Fallback Download URL: $downloadUrl');

              final fileResponse = await http.get(
                Uri.parse(downloadUrl),
                headers: {'Authorization': 'Bearer $token'},
              );

              debugPrint('Fallback File response status: ${fileResponse.statusCode}');
              debugPrint('Fallback File response content-type: ${fileResponse.headers['content-type']}');

              if (fileResponse.statusCode >= 200 && fileResponse.statusCode < 300) {
                final directory = await getApplicationDocumentsDirectory();
                final file = File('${directory.path}/${fileName ?? 'book'}.pdf');
                await file.writeAsBytes(fileResponse.bodyBytes);
                Utils.showToast('Book downloaded successfully', false);
                await OpenFile.open(file.path);
                return;
              } else {
                Utils.showToast('Failed to download PDF file: ${fileResponse.statusCode}', true);
                return;
              }
            } else {
              Utils.showToast('Server returned invalid JSON on fallback', true);
              return;
            }
          } catch (e) {
            debugPrint('GET fallback error: $e');
            Utils.showToast('Unexpected error during download', true);
            return;
          }
        }

        if (contentType.contains('application/json')) {
          final responseBody = _tryDecodeJson(response.body);
          if (responseBody is! Map<String, dynamic>) {
            Utils.showToast('Server returned invalid JSON response', true);
            return;
          }

          // Prefer the ready-made absolute downloadUrl from the API
          String? downloadUrl = responseBody['downloadUrl']?.toString();

          // Fallback: reconstruct from downloadedFilePath if downloadUrl is missing
          if (downloadUrl == null || downloadUrl.isEmpty) {
            final String? filePath =
            responseBody['downloadedFilePath']?.toString();
            if (filePath == null || filePath.isEmpty) {
              Utils.showToast('Download path is missing in response', true);
              return;
            }

            // If the API returned a relative path, build an absolute URL.
            // Avoid duplicating 'story-sign-backend' segment if baseURL already contains it.
            final String domain = BaseService().baseURL.replaceAll('/api/v1', '');
            if (filePath.startsWith('http')) {
              downloadUrl = filePath;
            } else if (filePath.startsWith('/')) {
              downloadUrl = '$domain$filePath';
            } else {
              downloadUrl = '$domain/$filePath';
            }
          }

          debugPrint('Download URL: $downloadUrl');

          final fileResponse = await http.get(
            Uri.parse(downloadUrl),
            headers: {'Authorization': 'Bearer $token'},
          );

          debugPrint('File response status: ${fileResponse.statusCode}');
          debugPrint(
            'File response content-type: ${fileResponse.headers['content-type']}',
          );

          if (fileResponse.statusCode >= 200 && fileResponse.statusCode < 300) {
            final fileContentType =
                fileResponse.headers['content-type']?.toLowerCase() ?? '';

            // Guard against silently saving an HTML error page as a .pdf
            if (fileContentType.isNotEmpty &&
                !fileContentType.contains('pdf') &&
                !fileContentType.contains('octet-stream')) {
              debugPrint('Unexpected file response body: ${fileResponse.body}');

              Utils.showToast(
                'Unexpected file type received: $fileContentType',
                true,
              );
              return;
            }

            final directory = await getApplicationDocumentsDirectory();
            final file = File('${directory.path}/${fileName ?? 'book'}.pdf');
            await file.writeAsBytes(fileResponse.bodyBytes);

            Utils.showToast('Book downloaded successfully', false);
            await OpenFile.open(file.path);
          } else {
            Utils.showToast(
              'Failed to download PDF file: ${fileResponse.statusCode}',
              true,
            );
            debugPrint('File GET failed body: ${fileResponse.body}');
          }
        } else {
          // Direct binary response from the POST itself
          final directory = await getApplicationDocumentsDirectory();
          final file = File('${directory.path}/${fileName ?? 'book'}.pdf');
          await file.writeAsBytes(response.bodyBytes);
          Utils.showToast('Book downloaded successfully', false);
          await OpenFile.open(file.path);
        }
      } else {
        Utils.showToast('Error: ${response.statusCode}', true);
      }
    } catch (e) {
      Utils.showToast('Error: $e', true);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> _downloadFileFromUrl(
      String? downloadUrl, String? fileName, String token) async {
    if (downloadUrl == null || downloadUrl.isEmpty) {
      Utils.showToast('Download URL is invalid or empty', true);
      return;
    }

    final fileResponse = await http.get(
      Uri.parse(downloadUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    debugPrint('File response status: ${fileResponse.statusCode}');
    debugPrint(
      'File response content-type: ${fileResponse.headers['content-type']}',
    );

    if (fileResponse.statusCode >= 200 && fileResponse.statusCode < 300) {
      final fileContentType =
          fileResponse.headers['content-type']?.toLowerCase() ?? '';

      if (fileContentType.isNotEmpty &&
          !fileContentType.contains('pdf') &&
          !fileContentType.contains('octet-stream')) {
        debugPrint('Unexpected file response body: ${fileResponse.body}');
        Utils.showToast(
          'Unexpected file type received: $fileContentType',
          true,
        );
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${fileName ?? 'book'}.pdf');
      await file.writeAsBytes(fileResponse.bodyBytes);
      Utils.showToast('Book downloaded successfully', false);
      await OpenFile.open(file.path);
    } else {
      Utils.showToast('Failed to download PDF file: ${fileResponse.statusCode}', true);
      debugPrint('File GET failed body: ${fileResponse.body}');
    }
  }

  dynamic _tryDecodeJson(String source) {
    try {
      return jsonDecode(source);
    } catch (e) {
      return null;
    }

    // }
    // Future<void> downloadBook(String autographRequestId, String? fileName) async {
    //   if (autographRequestId.trim().isEmpty) {
    //     Utils.showToast('Unable to download book: request ID missing', true);
    //     return;
    //   }
    //
    //   try {
    //     // 1. POST request — JSON response milta hai (file path ke sath)
    //     final response = await BaseService().basePostAPI(
    //       ApiEndPoints.downloadBook(autographRequestId),
    //       {'autographRequestId': autographRequestId},
    //     );
    //
    //     if (response['success'] != true) {
    //       // basePostAPI already error toast dikha chuka hoga
    //       return;
    //     }
    //
    //     final String? filePath = response['downloadedFilePath']?.toString();
    //     if (filePath == null || filePath.isEmpty) {
    //       Utils.showToast('Download path is missing in response', true);
    //       return;
    //     }
    //
    //     // Domain nikal ke clean file URL banao
    //     final String domain = BaseService().baseURL.replaceAll('/api/v1', '');
    //     final String downloadUrl = '$domain/$filePath';
    //
    //     print("Download URL: $downloadUrl");
    //
    //     final token =
    //         SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
    //
    //     EasyLoading.show(
    //       status: 'Downloading...',
    //       maskType: EasyLoadingMaskType.black,
    //     );
    //
    //     // 2. GET request — raw PDF bytes (yahan baseGetAPI use NAHI ho sakta,
    //     // kyunki wo json.decode karta hai response body par, jo binary
    //     // file data ke liye crash ho jayega)
    //     final fileResponse = await http.get(
    //       Uri.parse(downloadUrl),
    //       headers: {'Authorization': 'Bearer $token'},
    //     );
    //
    //     if (fileResponse.statusCode == 200) {
    //       final directory = await getApplicationDocumentsDirectory();
    //       final file = File('${directory.path}/${fileName ?? 'book'}.pdf');
    //       await file.writeAsBytes(fileResponse.bodyBytes);
    //
    //       Utils.showToast('Book downloaded successfully', false);
    //       await OpenFile.open(file.path);
    //     } else {
    //       Utils.showToast(
    //         'Failed to download PDF file: ${fileResponse.statusCode}',
    //         true,
    //       );
    //     }
    //   } catch (e) {
    //     debugPrint('downloadBook error: $e');
    //     Utils.showToast('Error: $e', true);
    //   } finally {
    //     EasyLoading.dismiss();
    //   }
    // }
  }
}
