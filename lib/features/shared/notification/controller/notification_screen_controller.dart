import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storysign/features/reader/notification/model/notification_model.dart';

abstract class NotificationScreenController extends GetxController {
  RxBool get isNotificationsLoading;
  RxBool get isLoadingMoreNotifications;
  RxList<NotificationModel> get notificationList;
  RxString get errorMessage;
  ScrollController get scrollController;
  Future<void> markAllAsRead();
  Future<void> refreshAlert();
}
