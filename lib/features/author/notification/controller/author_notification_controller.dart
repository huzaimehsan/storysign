import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/utility.dart';
import '../../../reader/notification/model/notification_model.dart';
import '../../../shared/notification/notification_screen_controller.dart';
// 👈 NAYA IMPORT

class AuthorNotificationController extends NotificationScreenController { // 👈 CHANGE 1: naam badla + extends badla

  @override // 👈 CHANGE 2: @override lagaya
  var isNotificationsLoading = false.obs;

  @override // 👈 CHANGE 2: @override lagaya
  var notificationList = <NotificationModel>[].obs; // 👈 CHANGE 3: model badla (AuthorNotificationModel -> NotificationModel)

  var unreadCount = 0.obs;
  String role = 'author';

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  @override // 👈 override lagana zaroori hai kyunke interface mein ye method hai
  Future<void> refreshAlert() async {
    await Future.wait([
      getNotifications(),
    ]);
  }

  final BaseService baseService = BaseService();

  Future<void> getNotifications() async {
    try {
      isNotificationsLoading.value = true;

      final Map<String, dynamic> response = await baseService.baseGetAPI(ApiEndPoints.authorNotifications);

      if (response['success'] == true) {
        List<dynamic> list = response['items'] ?? [];

        final allNotifications = list
            .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>)) // model yahan bhi badla
            .toList();

        notificationList.value = allNotifications.where((n) => !n.isRead).toList();
        unreadCount.value = notificationList.length;

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

  @override // 👈 comment se nikala aur override lagaya, kyunke interface mangta hai
  Future<void> markAllAsRead() async {
    try {
      debugPrint('AuthorNotificationController: markAllAsRead called. Total: ${notificationList.length}');

      final unreadList = notificationList.where((n) => !n.isRead).toList();
      if (unreadList.isEmpty) return;

      final results = await Future.wait(
        unreadList.map((notification) async {
          final endpoint = ApiEndPoints.markNotificationAsRead(notification.id);
          final res = await baseService.basePatchAPI(endpoint, body: {}, loading: false);
          return {'id': notification.id, 'success': res['success'] == true};
        }),
      );

      final successIds = results
          .where((r) => r['success'] == true)
          .map((r) => r['id'] as String)
          .toSet();

      notificationList.removeWhere((n) => successIds.contains(n.id));

      final failedCount = results.length - successIds.length;
      if (failedCount > 0) {
        Utils.showToast("Kuch notifications read nahi ho payin", true);
      }

      unreadCount.value = notificationList.where((n) => !n.isRead).length;
    } catch (e) {
      debugPrint("Error marking all as read: $e");
      Utils.showToast("Something went wrong", true);
      getNotifications();
    }
  }
}