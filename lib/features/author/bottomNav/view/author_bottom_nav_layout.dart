import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/constants/color_constants.dart';
import 'package:storysign/features/author/bottomNav/controller/author_bottom_nav_controller.dart';
import 'package:storysign/features/author/delivered/view/delivered_screen.dart';
import 'package:storysign/features/author/profile/view/author_profile.dart';
import 'package:storysign/features/author/request/view/all_request.dart';
import 'package:storysign/features/author/home/view/author_home_screen.dart';
import 'package:storysign/features/author/request/view/ebook_preview.dart';
import 'package:storysign/features/author/request/view/request_detail.dart';
import 'package:storysign/features/author/request/view/draw_signature.dart';
import 'package:storysign/features/author/request/view/place_signature.dart';
import 'package:storysign/features/author/request/view/add_message.dart';
import 'package:storysign/features/author/request/view/final_review.dart';
import 'package:storysign/features/reader/profile/view/profile_screen.dart';

import '../../../reader/library/view/reader_library.dart';


class AuthorBottomNavLayout extends GetView<AuthorBottomNavController> {
  AuthorBottomNavLayout({super.key});

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  // // Tab 0 (Home) ka initial route tree
  // Route _buildHomeRoute(RouteSettings settings) {
  //   switch (settings.name) {
  //     case '/trackrequest':
  //       return MaterialPageRoute(builder: (_) => const TrackRequest());
  //
  //
  //     default:
  //
  //
  //       return MaterialPageRoute(builder: (_) => const HomeScreen());
  //   }
  // }

  Route _buildRequestRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/requestDetail':
        return MaterialPageRoute(builder: (_) => const RequestDetailAuthor(),
        settings: settings,
        );

        case '/pdfReview':
        return MaterialPageRoute(builder: (_) => const BookPreviewPage());
      case '/drawSignature':
        return MaterialPageRoute(builder: (_) => const DrawSignatureScreen());
      case '/placeSignature':
        return MaterialPageRoute(builder: (_) => const PlaceSignatureScreen());
      case '/addMessage':
        return MaterialPageRoute(builder: (_) => const AddMessageScreen());
      case '/authorFinalReview':
        return MaterialPageRoute(builder: (_) => const AuthorFinalReviewScreen());
      default:
        return MaterialPageRoute(builder: (_) => const AllRequest());
    }
  }

  // AuthorBottomNavLayout file mein ye changes karein:





  Route _buildDeliveredRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/requestDetail':
        return MaterialPageRoute(builder: (_) => const RequestDetailAuthor(),settings: settings);


      default:
        return MaterialPageRoute(builder: (_) => const DeliveredScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        final currentNavigator =
            _navigatorKeys[controller.currentIndex.value].currentState;
        if (currentNavigator != null && currentNavigator.canPop()) {
          currentNavigator.pop();
        }
      },
      child: Scaffold(
        extendBody: true,
        body: Obx(
          () => IndexedStack(
            index: controller.currentIndex.value,
            children: [
              // Tab 0: Home (nested navigator — TrackRequest bhi iske andar push hogi)
              Navigator(
                key: _navigatorKeys[0],
                onGenerateRoute: (_) =>
                    MaterialPageRoute(builder: (_) => AuthorHomeScreen()),
              ),
              // Tab 1: Search
              Navigator(
                key: _navigatorKeys[1],
                onGenerateRoute: _buildRequestRoute,
              ),
              // Tab 2: Library
              Navigator(
                key: _navigatorKeys[2],
                onGenerateRoute:_buildDeliveredRoute,

              ),
              // Tab 3: Notifications

              // Tab 4: Profile
              Navigator(
                key: _navigatorKeys[3],
                onGenerateRoute: (_) =>
                    MaterialPageRoute(builder: (_) => AuthorProfileScreen()),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 2.h),
          height: 8.5.h,
          decoration: BoxDecoration(
            color: bottomNavColor,
            borderRadius: BorderRadius.circular(25.sp),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem("assets/icon/home.png", 0),
                _buildNavItem("assets/icon/request.png", 1),
                _buildNavItem("assets/icon/deliver.png", 2),

                _buildNavItem("assets/icon/profile.png", 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String imagePath, int index) {
    return Obx(() {
      final isSelected = controller.currentIndex.value == index;
      return GestureDetector(
        onTap: () => controller.changeIndex(index),
        child: SizedBox(
          width: 13.w,
          height: 13.w,
          child: Image.asset(
            imagePath,
            color: isSelected ? buttonColor : iconColor,
            fit: BoxFit.contain,
          ),
        ),
      );
    });
  }
}
