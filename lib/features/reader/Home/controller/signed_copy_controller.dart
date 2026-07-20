import 'dart:convert';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';

class SignedCopyController extends GetxController {
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

          final String downloadUrl =
              Uri.parse('${BaseService().baseURL}/$filePath').toString();
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
          } else {
            Utils.showToast('Failed to download PDF file', true);
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

  dynamic _tryDecodeJson(String source) {
    try {
      return jsonDecode(source);
    } catch (e) {
      return null;
    }
  }
}
