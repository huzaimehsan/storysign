import 'package:get/get.dart';
import 'package:storysign/features/reader/notification/model/notification_model.dart';


abstract class NotificationScreenController extends GetxController {
  RxBool get isNotificationsLoading;
  RxList<NotificationModel> get notificationList;
  RxString get errorMessage;
  Future<void> markAllAsRead();
  Future<void> refreshAlert();
}
