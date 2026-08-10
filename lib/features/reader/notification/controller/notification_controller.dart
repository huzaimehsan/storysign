import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/utility.dart';
import '../../../shared/notification/controller/notification_screen_controller.dart';
import '../model/notification_model.dart';


class NotificationController extends NotificationScreenController {

  @override
  var isNotificationsLoading = false.obs;
  @override
  var isLoadingMoreNotifications = false.obs;
  @override
  var notificationList = <NotificationModel>[].obs;
  @override
  var errorMessage = ''.obs;
  @override
  final ScrollController scrollController = ScrollController();

  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;

  var unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    getNotifications();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 120 &&
        !isNotificationsLoading.value &&
        !isLoadingMoreNotifications.value &&
        currentPage.value < totalPages.value) {
      getNotifications(page: currentPage.value + 1, loadMore: true);
    }
  }

  @override
  Future<void> refreshAlert() async {
    await Future.wait([
      getNotifications(),
    ]);
  }

  final BaseService baseService = BaseService();
  Future<void> getNotifications({int page = 1, int limit = 20, bool loadMore = false}) async {
    try {
      if (loadMore) {
        isLoadingMoreNotifications.value = true;
      } else {
        isNotificationsLoading.value = true;
      }
      errorMessage.value = '';

      final Map<String, dynamic> response = await baseService.baseGetAPI(
        ApiEndPoints.readerNotifications(page: page, limit: limit),
        loading: false,
        showErrorToast: false,
      );

      if (response != null && response['success'] == true) {
        List<dynamic> list = response['items'] ?? [];
        final allNotifications = list
            .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
            .toList();

        final filtered = allNotifications.where((n) => !n.isRead).toList();
        if (loadMore) {
          notificationList.addAll(filtered);
        } else {
          notificationList.value = filtered;
        }
        unreadCount.value = notificationList.length;
        currentPage.value = response['page'] ?? page;
        totalPages.value = response['totalPages'] ?? totalPages.value;
      } else {
        if (loadMore && currentPage.value > 1) currentPage.value--;
        errorMessage.value = response?['message']?.toString() ?? "Failed to load notifications";
        Utils.showToast(errorMessage.value, true);
      }
    } catch (e) {
      errorMessage.value = "Error fetching notifications: $e";
      debugPrint("Error fetching notifications: $e");
    } finally {
      if (loadMore) {
        isLoadingMoreNotifications.value = false;
      } else {
        isNotificationsLoading.value = false;
      }
    }
  }
  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  @override // 👈 lagaya
  Future<void> markAllAsRead() async {
    try {
      debugPrint('NotificationController: markAllAsRead called. Total notifications: ${notificationList.length}');

      final unreadList = notificationList.where((n) => !n.isRead).toList();
      debugPrint('NotificationController: unread count = ${unreadList.length}');
      if (unreadList.isEmpty) return;

      final results = await Future.wait(
        unreadList.map((notification) async {
          final endpoint = ApiEndPoints.markNotificationAsRead(notification.id);
          debugPrint('Marking read -> $endpoint');
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
        Utils.showToast("No Notification", true);
      }

      unreadCount.value = notificationList.where((n) => !n.isRead).length;
    } catch (e) {
      debugPrint("Error marking all as read: $e");
      Utils.showToast("Something went wrong", true);
      getNotifications();
    }
  }
}