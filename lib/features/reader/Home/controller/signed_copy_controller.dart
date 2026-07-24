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
      autographRequestId = args['autographRequestId']?.toString() ??
          args['requestId']?.toString() ??
          args['bookId']?.toString();

      debugPrint('Extracted autographRequestId -> $autographRequestId');

      if (autographRequestId != null && autographRequestId!.isNotEmpty) {
        bookDetailCopy(autographRequestId);
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
      final response = await BaseService().baseGetAPI(endpoint);

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
      // baseGetAPI already error case mein specific toast dikha chuka hoga —
      // isliye yahan generic toast dobara mat lagao, warna double toast aayega.
      // Sirf tab dikhao jab error humara apna hai (jaise parsing fail):
      if (e.toString().contains('Failed to parse data')) {
        Utils.showToast(errorMessage.value, true);
      }
    } finally {
      isloading.value = false;
    }
  }
  Future<void> downloadBook(String autographRequestId, String? fileName) async {
    if (autographRequestId.trim().isEmpty) {
      Utils.showToast('Unable to download book: request ID missing', true);
      return;
    }

    try {
      EasyLoading.show(
        status: 'Downloading...',
        maskType: EasyLoadingMaskType.black,
      );

      final token =
          SharedPreferencesMethod.storage.getString(LocalDBKeys.TOKEN) ?? '';
      if (token.isEmpty) {
        Utils.showToast('Please login again', true);
        return;
      }

      final uri = Uri.parse(
        '${BaseService().baseURL}${ApiEndPoints.downloadBook(autographRequestId)}',
      );

      // 1. POST Request to get JSON containing the file path
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'autographRequestId': autographRequestId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final contentType =
            response.headers['content-type']?.toLowerCase() ?? '';

        if (contentType.contains('application/json')) {
          final responseBody = _tryDecodeJson(response.body);
          if (responseBody is! Map<String, dynamic>) {
            Utils.showToast('Server returned invalid JSON response', true);
            return;
          }

          final String? filePath =
          responseBody['downloadedFilePath']?.toString();
          if (filePath == null || filePath.isEmpty) {
            Utils.showToast('Download path is missing in response', true);
            return;
          }

          // 💡 FIXED: Remove '/api/v1' to get the clean domain name
          final String domain = BaseService().baseURL.replaceAll('/api/v1', '');
          final String downloadUrl = '$domain/$filePath';

          print("Download URL: $downloadUrl"); // Debugging ke liye check karlein

          // 2. GET Request to download the actual PDF file bytes
          final fileResponse = await http.get(
            Uri.parse(downloadUrl),
            headers: {'Authorization': 'Bearer $token'},
          );

          if (fileResponse.statusCode == 200) {
            final directory = await getApplicationDocumentsDirectory();
            final file =
            File('${directory.path}/${fileName ?? 'book'}.pdf');
            await file.writeAsBytes(fileResponse.bodyBytes);


            Utils.showToast('Book downloaded successfully', false);

            // File download hone ke baad foran open karne ke liye:
            await OpenFile.open(file.path);
          } else {
            Utils.showToast('Failed to download PDF file: ${fileResponse.statusCode}', true);
          }
        } else {
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

  dynamic _tryDecodeJson(String source)
{
try
{
return
jsonDecode
(
source
);
}
catch
(
e
)
{
return
null;
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