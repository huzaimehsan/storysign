import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storysign/features/author/bottomNav/binding/author_bottom_nav_binding.dart';
import 'package:storysign/features/author/bottomNav/controller/author_bottom_nav_controller.dart';
import 'package:storysign/features/author/request/view/all_request.dart';
import 'package:storysign/features/author/request/view/ebook_preview.dart';
import 'package:storysign/features/author/request/view/draw_signature.dart';
import 'package:storysign/features/author/request/view/place_signature.dart';

import 'package:storysign/features/author/subscriptionplan/view/subscription_plan.dart';
import 'package:storysign/features/reader/Home/binding/home_binding.dart';
import 'package:storysign/features/reader/Home/binding/request_autograph_binding.dart';
import 'package:storysign/features/reader/Home/binding/request_detail_binding.dart';
import 'package:storysign/features/reader/Home/binding/track_request_binding.dart';
import 'package:storysign/features/reader/Home/binding/payment_binding.dart';
import 'package:storysign/features/reader/Home/binding/select_author_binding.dart';
import 'package:storysign/features/reader/Home/binding/signed_copy_binding.dart';
import 'package:storysign/features/reader/Home/binding/upload_book_binding.dart';
import 'package:storysign/features/reader/Home/controller/home_controller.dart';
import 'package:storysign/features/reader/Home/view/final_review.dart';
import 'package:storysign/features/reader/Home/view/make_payment.dart';
import 'package:storysign/features/reader/Home/view/request_detail.dart';
import 'package:storysign/features/reader/Home/view/signed_copy.dart';
import 'package:storysign/features/reader/Home/view/tracking_screen.dart';
import 'package:storysign/features/reader/Home/view/upload_book.dart';
import 'package:storysign/features/reader/library/binding/reader_library_binding.dart';
import 'package:storysign/features/reader/notification/binding/notification_binding.dart';
import 'package:storysign/features/reader/profile/binding/profile_binding.dart';
import 'package:storysign/features/reader/profile/view/change_password.dart';
import 'package:storysign/features/reader/profile/view/contact_us.dart';
import 'package:storysign/features/reader/profile/view/edit_profile.dart';

import 'package:storysign/features/reader/profile/view/privacy_policy.dart';
import 'package:storysign/features/reader/profile/view/profile_screen.dart';
import 'package:storysign/features/reader/search/binding/search_binding.dart';

import '../../features/author/bottomNav/view/author_bottom_nav_layout.dart';
import '../../features/author/request/view/request_detail.dart';
import '../../features/author/subscriptionplan/view/subscription_plan_selection.dart';
import '../../features/reader/Home/view/request_autograph.dart';
import '../../features/reader/Home/view/select_author.dart';
import '../../features/reader/Home/view/track_request.dart';
import '../../features/reader/auth/binding/auth_binding.dart';
import '../../features/reader/auth/view/choose_role.dart';
import '../../features/reader/auth/view/forgot_password/resend_otp.dart';
import '../../features/reader/auth/view/forgot_password/reset_password.dart';
import '../../features/reader/auth/view/forgot_password/send_otp.dart';
import '../../features/reader/auth/view/sign_in.dart';
import '../../features/reader/auth/view/sign_up.dart';
import '../../features/reader/auth/view/splash_screen.dart';
import '../../features/reader/bottomNav/binding/bottom_nav_binding.dart';
import '../../features/reader/bottomNav/view/bottom_nav_layout.dart';
import '../../features/reader/library/view/reader_library.dart';
import '../../features/reader/notification/view/notification.dart';
import '../../features/reader/profile/view/help_and_support.dart';
import '../../features/reader/search/view/author_detail.dart';
import '../../features/reader/search/view/request_autograph.dart';

class AppRoutes {
  static List<GetPage<dynamic>> routes = [
    GetPage(name: '/', page: () => SplashScreen(),binding: AuthBinding()),

    GetPage(name: '/signin', page: () => SignIn(),binding: AuthBinding()),
    GetPage(name: '/signup', page: () => SignUp(),binding: AuthBinding()),

    GetPage(name: '/reset', page: () => ResetPassword(),binding: AuthBinding()),
    GetPage(name: '/sendotp', page: () => SendOtp(),binding: AuthBinding()),

    GetPage(name: '/resendotp', page: () => ResendOtp(),binding: AuthBinding()),
    GetPage(name: '/chooserole', page: () => ChooseRole(),binding: AuthBinding()),


    GetPage(name: '/bottomnav', page: () => MyBottomBarScreen(),binding: BottomNavBinding()),
    GetPage(
      name: '/trackrequest',
      page: ()
        // Har baar route open hone par fresh data fetch — same as search screen pattern
        // Get.find<HomeController>().fetchTrackRequestData();
        // return const
   => TrackRequest(),

      binding: TrackRequestBinding(),
    ),

    GetPage(
      name: '/authordetail',
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        return AuthorDetail(
          authorId: args?['authorId']?.toString() ?? '',
          role: args?['role']?.toString() ?? '',
        );
      },
      binding: SearchBinding(),
    ),


    GetPage(name: '/readerlibrary', page: () => ReaderLibrary(),binding: ReaderLibraryBinding()),



    GetPage(name: '/requestautograph', page: () => RequestAutograph(),binding: RequestAutographBinding()),



    GetPage(name: '/notification', page: () => NotificationScreen(),binding: NotificationBinding()),


    GetPage(name: '/requestautographcard', page: () => RequestAutographCard(),binding: RequestAutographBinding()),


    GetPage(name: '/uploadbook', page: () => UploadBook(),binding: UploadBookBinding()),


    GetPage(name: '/selectauthor', page: () => SelectAuthor(), binding: SelectAuthorBinding()),
    GetPage(name: '/request', page: () => RequestDetail(), bindings: [RequestDetailBinding(), PaymentBinding()]),
    GetPage(name: '/makepayment', page: () => MakePayment(), binding: PaymentBinding()),

    GetPage(name: '/finalreview', page: () => FinalReview(), binding: PaymentBinding()),

    GetPage(name: '/tracking', page: () => TrackingScreen(), binding: TrackRequestBinding()),

    GetPage(name: '/signedcopy', page: () => SignedCopy(), binding: SignedCopyBinding()),
    GetPage(name: '/profile', page: () => ProfileScreen(),binding: ProfileBinding()),
    GetPage(name: '/editprofile', page: () => EditProfile(),binding: ProfileBinding()),


    GetPage(name: '/helpandsupport', page: () => HelpAndSupport(),binding: ProfileBinding()),
    GetPage(name: '/newpass', page: () => ChangePassword(),binding: ProfileBinding()),

    GetPage(name: '/contact', page: () => ContactUs(),binding: ProfileBinding()),
    GetPage(name: '/privacy', page: () => PrivacyPolicy(),binding: ProfileBinding()),

    GetPage(name: '/authorbottomnav', page: () => AuthorBottomNavLayout(),binding: AuthorBottomNavBinding()),

  GetPage(name: '/plan', page: () => SubscriptionPlan(),binding: AuthorBottomNavBinding()),
    GetPage(name: '/selectplan', page: () => SubscriptionPlanSelectionScreen(),binding: AuthorBottomNavBinding()),


    GetPage(name: '/allRequest', page: () => AllRequest(),binding: AuthorBottomNavBinding()),

    GetPage(name: '/requestDetail', page: () => RequestDetailAuthor(),binding: AuthorBottomNavBinding()),


    GetPage(name: '/pdfReview', page: () => BookPreviewPage(),binding: AuthorBottomNavBinding()),
    GetPage(name: '/drawSignature', page: () => const DrawSignatureScreen(),binding: AuthorBottomNavBinding()),

    GetPage(name: '/placeSignature', page: () => const PlaceSignatureScreen(),binding: AuthorBottomNavBinding()),

    // GetPage(name: '/onboardingone', page: () => OnboardingOne(),binding: OnboardingBinding()),
    // GetPage(name: '/helpsupport', page: () => SettingScreen(),binding: SettingBinding()),
    // GetPage(name: '/aboutus', page: () => AboutUsScreen(),binding: SettingBinding()),
    // GetPage(name: '/support', page: () => SupportScreen(),binding: SettingBinding()),
    // GetPage(name: '/terms', page: () => TermsScreen(),binding: SettingBinding()),
    // GetPage(name: '/faqs', page: () => FaqsScreen(),binding: SettingBinding()),
    // GetPage(name: '/notifications', page: () => NotificationScreen(),binding: NotificationBinding()),
    // GetPage(name: '/signup', page: () => SignupScreen(),binding: AuthBinding()),
    // GetPage(name: '/otp', page: () => OtpVerification(),binding: AuthBinding()),
    // GetPage(name: '/login', page: () => LoginScreen(),binding: AuthBinding()),
    // GetPage(name: '/email', page: () => EnterEmailScreen(),binding: AuthBinding()),
    // GetPage(name: '/forgotsetpassword', page: () => ForgotSetPassword(),binding: AuthBinding()),
    // GetPage(name: '/order', page: () => OrderScreen(),binding: OrderBinding()),
    // GetPage(name: '/trackOrder', page: () => TrackOrderScreen(),binding: OrderBinding()),
    // GetPage(name: '/trackOrder', page: () => TrackOrderScreen(),binding: OrderBinding()),
    // GetPage(name: '/fleet', page: () => FleetScreen(),binding: FleetBinding()),
    // GetPage(name: '/seeVehicle', page: () => SeeVehicle(),binding: FleetBinding()),
    // GetPage(name: '/seeEquipments', page: () => SeeEquipments(),binding: FleetBinding()),
    // GetPage(name: '/profile', page: () => ProfileScreen(),binding: ProfileBinding()),
    // GetPage(name: '/editprofile', page: () => EditProfileScreen(),binding: ProfileBinding()),
    // GetPage(name: '/changePassword', page: () => ChangePasswordScreen(),binding: ProfileBinding()),
    // GetPage(name: '/notificationSetting', page: () => NotificationSettingScreen(),binding: ProfileBinding()),
    // GetPage(name: '/home', page: () => HomeScreen(),binding: HomeBinding()),
    // GetPage(name: '/navbar', page: () => NavbarScreen(),binding: NavbarBinding()),
    // GetPage(name: '/choseplan', page: () => ChooseYourPlan()),
    // GetPage(name: '/SubscriptionPayment', page: () => SubscriptionPayment()),
    // GetPage(name: '/SubscriptionPlan', page: () => SubscriptionPlan()),
    // GetPage(name: '/AddPayment', page: () => AddPaymentScreen()),
    // GetPage(name: '/PaymentMethod', page: () => PaymentMethodScreen()),
  ];
}
