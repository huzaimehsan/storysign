import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sizer/sizer.dart';

import '../widget/notification_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notificationData = [
      {
        "title": "Your Signed copy is ready!",
        "desc":
            "Matt Haig has signed The Midnight Library. Download it now from your library.",
        "time": "2 hours ago",
      },
      {
        "title": "New Update!",
        "desc": "Your app version 2.0 is now live.",
        "time": "5 hours ago",
      },
      {
        "title": "Payment Received",
        "desc": "Your payment for 'The Great Gatsby' was successful.",
        "time": "1 day ago",
      },
      {
        "title": "Your Signed copy is ready!",
        "desc": "Matt Haig has signed The Midnight Library.",
        "time": "2 hours ago",
      },
      {
        "title": "New Update!",
        "desc": "Your app version 2.0 is now live.",
        "time": "5 hours ago",
      },
      {
        "title": "Payment Received",
        "desc": "Your payment for 'The Great Gatsby' was successful.",
        "time": "1 day ago",
      },
      {
        "title": "Your Signed copy is ready!",
        "desc": "Matt Haig has signed The Midnight Library.",
        "time": "2 hours ago",
      },
      {
        "title": "New Update!",
        "desc": "Your app version 2.0 is now live.",
        "time": "5 hours ago",
      },
      {
        "title": "Payment Received",
        "desc": "Your payment for 'The Great Gatsby' was successful.",
        "time": "1 day ago",
      },
    ];

    return Scaffold(
      body: SafeArea(

        child: Column(
          children: [

            customNotificationHeader(onBack: Get.back, onIconPressed: () {}),
            SizedBox(height: 1.h),


            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: 20.h),
                itemCount: notificationData.length,
                itemBuilder: (context, index) {
                  final data = notificationData[index];
                  return notificationTile(
                    title: data['title']!,
                    description: data['desc']!,
                    time: data['time']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
