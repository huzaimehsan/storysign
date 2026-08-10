import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/formatted_date_widget.dart';

import '../../../reader/notification/widget/notification_widget.dart';
import '../controller/notification_screen_controller.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments ?? Get.arguments) as Map<String, dynamic>?;
    final role = args?['role']?.toString() ?? 'reader';

    final NotificationScreenController controller = role == 'author'
        ? Get.find<NotificationScreenController>(tag: 'author')
        : Get.find<NotificationScreenController>(tag: 'reader');

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            customNotificationHeader(
              onBack: Get.back,
              onIconPressed: () => controller.markAllAsRead(),
            ),
            SizedBox(height: 1.h),
            Expanded(
              child: RefreshIndicator(
                      backgroundColor :containerColor,
       
                color: white,
                onRefresh: () => controller.refreshAlert(),
                child: Obx(() {
                  final notificationController = controller.notificationList;

                  if (controller.isNotificationsLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: buttonColor),
                    );
                  }

                  if (controller.errorMessage.value.isNotEmpty) {
                    return SizedBox(
                      height: 60.h,
                      child: Center(
                        child: customText(
                          text: controller.errorMessage.value,
                          color: greyColor,
                          fontSize: 15.sp,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }

                  if (notificationController.isEmpty) {
                    // When not loading and the list is empty, show a "No Notification found" message.
                    // Avoid scheduling a refresh every build (which caused the loader to loop).
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 40.h),
                        Center(
                          child: customText(
                            text: 'No Notification found',
                            color: greyColor,
                            fontSize: 15.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 12.h),
                    itemCount: notificationController.length +
                        (controller.isLoadingMoreNotifications.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == notificationController.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: CircularProgressIndicator(color: buttonColor),
                          ),
                        );
                      }
                      final data = notificationController[index];
                      return notificationTile(
                        title: data.title,
                        description: data.message,
                        time: timeAgo(data.createdAt),
                        isRead: data.isRead,
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String timeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);

    if (duration.inMinutes < 1) return 'Just now';
    if (duration.inMinutes < 60) return '${duration.inMinutes}m ago';
    if (duration.inHours < 24) return '${duration.inHours}h ago';
    if (duration.inDays < 7) return '${duration.inDays}d ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
