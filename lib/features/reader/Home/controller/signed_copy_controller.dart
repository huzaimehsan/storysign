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
      bookId =
          args['bookId']?.toString() ?? args['bookIdValue']?.toString() ?? '';

      debugPrint('Extracted autographRequestId -> $autographRequestId');
      debugPrint('Extracted bookId -> $bookId');

      if (autographRequestId != null && autographRequestId!.isNotEmpty) {
        bookDetailCopy(autographRequestId);
      } else if (bookId != null && bookId!.isNotEmpty) {
        debugPrint(
          'No autographRequestId provided; using bookId for download only',
        );
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

    if (resolvedAutographRequestId == null ||
        resolvedAutographRequestId.isEmpty) {
      Utils.showToast(
        'Unable to download book: autograph request ID missing',
        true,
      );
      return;
    }

    try {
      EasyLoading.show(
        status: 'Downloading...',
        maskType: EasyLoadingMaskType.black,
      );

      final token =
          SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
      debugPrint(
        'Download: token present=${token.isNotEmpty}, length=${token.length}',
      );
      if (token.isEmpty) {
        Utils.showToast('Please login again', true);
        return;
      }

      final uri = Uri.parse(
        '${BaseService().baseURL}${ApiEndPoints.downloadBook(resolvedBookId)}',
      );
      final Map<String, dynamic> requestBody = {
        'autographRequestId': resolvedAutographRequestId,
      };

      debugPrint('Download POST URI: $uri');
      debugPrint('Download POST requestBody: ${jsonEncode(requestBody)}');

      final postResponse = await BaseService().basePostAPI(
        ApiEndPoints.downloadBook(resolvedBookId),
        requestBody,
        loading: false,
      );

      debugPrint('Download POST response: $postResponse');

      if (postResponse['success'] == true) {
        final responseBody = postResponse;
        String? downloadUrl = responseBody['downloadUrl']?.toString();

        if (downloadUrl == null || downloadUrl.isEmpty) {
          final String? filePath = responseBody['downloadedFilePath']
              ?.toString();
          if (filePath == null || filePath.isEmpty) {
            Utils.showToast('Download path is missing in response', true);
            return;
          }

          final String domain = BaseService().baseURL.replaceAll('/api/v1', '');
          downloadUrl = filePath.startsWith('http')
              ? filePath
              : (filePath.startsWith('/')
                    ? '$domain$filePath'
                    : '$domain/$filePath');
        }

        await _downloadFileFromUrl(downloadUrl, fileName, token);
        return;
      }

      final fallbackResponse = await BaseService().basePostAPI(
        ApiEndPoints.downloadBook(resolvedBookId),
        requestBody,
        loading: false,
      );

      debugPrint('Fallback Download POST response: $fallbackResponse');

      if (fallbackResponse['success'] != true) {
        if (fallbackResponse['statusCode'] == 401) {
          Utils.showToast('Session expired. Please login again.', true);
          Get.offAllNamed('/signin');
          return;
        }

        Utils.showToast(
          fallbackResponse['message']?.toString() ?? 'Book download failed',
          true,
        );
        return;
      }

      final responseBody = fallbackResponse;
      String? downloadUrl = responseBody['downloadUrl']?.toString();
      if (downloadUrl == null || downloadUrl.isEmpty) {
        final String? filePath = responseBody['downloadedFilePath']?.toString();
        if (filePath == null || filePath.isEmpty) {
          Utils.showToast('Download path is missing in response', true);
          return;
        }

        final String domain = BaseService().baseURL.replaceAll('/api/v1', '');
        downloadUrl = filePath.startsWith('http')
            ? filePath
            : (filePath.startsWith('/')
                  ? '$domain$filePath'
                  : '$domain/$filePath');
      }

      debugPrint('Download URL: $downloadUrl');
      await _downloadFileFromUrl(downloadUrl, fileName, token);
      return;
    } catch (e) {
      Utils.showToast('Error: $e', true);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> _downloadFileFromUrl(
    String? downloadUrl,
    String? fileName,
    String token,
  ) async {
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

      // 1. Save to App's private documents directory (for opening with OpenFile)
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${fileName ?? 'book'}.pdf');
      await file.writeAsBytes(fileResponse.bodyBytes);

      // 2. Try to save to Public Downloads directory on Android
      String targetMessage = 'Book downloaded successfully';
      if (Platform.isAndroid) {
        try {
          final publicDownloadDir = Directory('/storage/emulated/0/Download');
          if (await publicDownloadDir.exists()) {
            var publicFile = File(
              '${publicDownloadDir.path}/${fileName ?? 'book'}.pdf',
            );
            int counter = 1;
            while (await publicFile.exists()) {
              publicFile = File(
                '${publicDownloadDir.path}/${fileName ?? 'book'}_$counter.pdf',
              );
              counter++;
            }
            await publicFile.writeAsBytes(fileResponse.bodyBytes);
            targetMessage = 'Book downloaded & saved to Downloads';
            debugPrint(
              "Saved to public download folder successfully: ${publicFile.path}",
            );
          }
        } catch (e) {
          debugPrint("Failed to save to public downloads folder: $e");
          // Fallback to app's external downloads directory if public folder isn't writable directly
          try {
            final extDirs = await getExternalStorageDirectories(
              type: StorageDirectory.downloads,
            );
            if (extDirs != null && extDirs.isNotEmpty) {
              var extFile = File(
                '${extDirs.first.path}/${fileName ?? 'book'}.pdf',
              );
              int counter = 1;
              while (await extFile.exists()) {
                extFile = File(
                  '${extDirs.first.path}/${fileName ?? 'book'}_$counter.pdf',
                );
                counter++;
              }
              await extFile.writeAsBytes(fileResponse.bodyBytes);
              targetMessage = 'Book saved to App External Storage';
              debugPrint(
                "Saved to app external downloads folder successfully: ${extFile.path}",
              );
            }
          } catch (extEx) {
            debugPrint(
              "Failed to save to app external downloads folder: $extEx",
            );
          }
        }
      }

      Utils.showToast(targetMessage, false);
      await OpenFile.open(file.path);
    } else {
      Utils.showToast(
        'Failed to download PDF file: ${fileResponse.statusCode}',
        true,
      );
      debugPrint('File GET failed body: ${fileResponse.body}');
    }
  }

  dynamic _tryDecodeJson(String source) {
    try {
      return jsonDecode(source);
    } catch (e) {
      return null;
    }
  }
}
