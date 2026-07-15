import 'package:flutter/material.dart'; // debugPrint ke liye
import 'package:get/get.dart';

import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/utility.dart'; // Utils ke liye
import '../model/notification_model.dart'; // Apne model ka path yahan sahi karein

class NotificationController extends GetxController {
  // Rx variables
  var isNotificationsLoading = false.obs;
  var notificationList = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getNotifications(); // Screen load hote hi call karne ke liye
  }

  Future<void> getNotifications() async {
    try {
      isNotificationsLoading.value = true;
      final BaseService baseService = BaseService();

      // 1. API Call karein
      final Map<String, dynamic> response = await baseService.baseGetAPI(ApiEndPoints.notifications);

      // 2. Success check karein
      if (response['success'] == true) {
        // 3. Response se 'items' wali list extract karein
        List<dynamic> list = response['items'] ?? [];

        // 4. Model mein convert karke list update karein
        notificationList.value = list
            .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
            .toList();

        debugPrint("Notifications loaded: ${notificationList.length}");
      } else {
        Utils.showToast(response['message'] ?? "Failed to load", true);
      }
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
      Utils.showToast("Something went wrong", true);
    } finally {
      isNotificationsLoading.value = false;
    }
  }
}