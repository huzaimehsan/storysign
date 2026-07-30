import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/utility.dart';
import '../../../reader/notification/model/notification_model.dart';
import '../../../shared/notification/controller/notification_screen_controller.dart';
// 👈 NAYA IMPORT

class AuthorNotificationController extends NotificationScreenController {
  @override
  var isNotificationsLoading = false.obs;

  @override
  var notificationList = <NotificationModel>[].obs;

  var unreadCount = 0.obs;
  String role = 'author';

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  @override
  Future<void> refreshAlert() async {
    await Future.wait([getNotifications()]);
  }

  final BaseService baseService = BaseService();

  Future<void> getNotifications() async {
    try {
      isNotificationsLoading.value = true;

      final Map<String, dynamic> response = await baseService.baseGetAPI(
        ApiEndPoints.authorNotifications,
        loading: false,
      );

      if (response['success'] == true) {
        List<dynamic> list = response['items'] ?? [];

        final allNotifications = list
            .map(
              (item) =>
                  NotificationModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();

        notificationList.value = allNotifications
            .where((n) => !n.isRead)
            .toList();
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

  @override
  Future<void> markAllAsRead() async {
    try {
      debugPrint(
        'AuthorNotificationController: markAllAsRead called. Total: ${notificationList.length}',
      );

      final unreadList = notificationList.where((n) => !n.isRead).toList();
      if (unreadList.isEmpty) return;

      final results = await Future.wait(
        unreadList.map((notification) async {
          final endpoint = ApiEndPoints.authorReadAllNotifications;
          final res = await baseService.basePatchAPI(
            endpoint,
            body: {},
            loading: false,
          );
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
        Utils.showToast("Nothing Happen", true);
      }

      unreadCount.value = notificationList.where((n) => !n.isRead).length;
    } catch (e) {
      debugPrint("Error marking all as read: $e");
      Utils.showToast("Something went wrong", true);
      getNotifications();
    }
  }
}
