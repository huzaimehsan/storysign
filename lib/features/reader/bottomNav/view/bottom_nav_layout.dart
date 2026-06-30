import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/constants/color_constants.dart';

import '../../Home/view/reader/home_screen.dart';
import '../../Home/view/reader/track_request.dart';
import '../../library/view/reader/reader_library.dart';
import '../../notification/view/notification.dart';
import '../../search/view/author_detail.dart';
import '../../search/view/search_screen.dart';
import '../controller/bottom_nav_controller.dart';

class MyBottomBarScreen extends GetView<BottomNavController> {
  MyBottomBarScreen({super.key});

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  // Tab 0 (Home) ka initial route tree
  Route _buildHomeRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/trackrequest':
        return MaterialPageRoute(builder: (_) => const TrackRequest());


        default:


        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }

  Route _buildSeacrhRoute(RouteSettings settings) {
    switch (settings.name) {

      case  '/authordetail':
        return MaterialPageRoute(builder: (_) => const AuthorDetail());
      default:


        return MaterialPageRoute(builder: (_) => const SearchScreen());
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
                onGenerateRoute: _buildHomeRoute,
              ),
              // Tab 1: Search
              Navigator(
                key: _navigatorKeys[1],
                onGenerateRoute: _buildSeacrhRoute,
              ),
              // Tab 2: Library
              Navigator(
                key: _navigatorKeys[2],
                onGenerateRoute: (_) => MaterialPageRoute(
                    builder: (_) => ReaderLibrary()
                        ),
              ),
              // Tab 3: Notifications
              Navigator(
                key: _navigatorKeys[3],
                onGenerateRoute: (_) => MaterialPageRoute(
                    builder: (_) =>
                        NotificationScreen()),
              ),
              // Tab 4: Profile
              Navigator(
                key: _navigatorKeys[4],
                onGenerateRoute: (_) => MaterialPageRoute(
                    builder: (_) =>
                        const Center(child: Text("Profile Page"))),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
            bottom: 2.h,
          ),
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
                _buildNavItem("assets/icon/search.png", 1),
                _buildNavItem("assets/icon/library.png", 2),
                _buildNavItem("assets/icon/notification.png", 3),
                _buildNavItem("assets/icon/profile.png", 4),
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