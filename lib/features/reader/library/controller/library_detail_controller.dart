import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/utility.dart';
import '../model/library_detail_model.dart';

class ReaderLibraryDetailController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<ReaderLibraryBookDetailModel?> detail = Rx<ReaderLibraryBookDetailModel?>(null);

  Future<void> fetchBookDetail(String bookId) async {
    if (bookId.isEmpty) {
      Utils.showToast('Book id is missing', true);
      return;
    }

    try {
      isLoading.value = true;
      final response = await BaseService().baseGetAPI(
        '${ApiEndPoints.listMyBook}/$bookId',
        loading: false,
      );

      if (response['success'] == true) {
        final payload = response['data'] ?? response;
        if (payload is Map<String, dynamic>) {
          detail.value = ReaderLibraryBookDetailModel.fromJson(payload);
        } else {
          Utils.showToast('Invalid response', true);
        }
      } else {
        Utils.showToast(response['message'] ?? 'Unable to load book details', true);
      }
    } catch (e) {
      debugPrint('Book detail error: $e');
      Utils.showToast('Something went wrong', true);
    } finally {
      isLoading.value = false;
    }
  }
}
