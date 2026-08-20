
import 'package:get/get.dart';
import 'package:storysign/features/author/bottomNav/binding/author_bottom_nav_binding.dart';
import 'package:storysign/features/author/profile/binding/help_support_binding.dart';
import 'package:storysign/features/author/profile/binding/profile_binding.dart';
import 'package:storysign/features/author/request/binding/draw_signature_binding.dart';
import 'package:storysign/features/author/request/binding/ebook_preview_binding.dart';
import 'package:storysign/features/author/request/binding/final_review_binding.dart';
import 'package:storysign/features/author/request/binding/place_signature_binding.dart';
import 'package:storysign/features/author/request/binding/request_binding.dart';
import 'package:storysign/features/author/request/view/all_request.dart';
import 'package:storysign/features/author/request/view/ebook_preview.dart';
import 'package:storysign/features/author/request/view/draw_signature.dart';
import 'package:storysign/features/author/request/view/final_review.dart';
import 'package:storysign/features/author/request/view/place_signature.dart';

import 'package:storysign/features/author/subscriptionplan/binding/stripe_payment_binding.dart';
import 'package:storysign/features/author/subscriptionplan/binding/subscription_plan_binding.dart';
import 'package:storysign/features/author/subscriptionplan/view/subscription_plan.dart';


import 'package:storysign/features/reader/Home/binding/request_autograph_binding.dart';

import 'package:storysign/features/reader/Home/binding/track_request_binding.dart';
import 'package:storysign/features/reader/Home/binding/payment_binding.dart';
import 'package:storysign/features/reader/Home/binding/select_author_binding.dart';
import 'package:storysign/features/reader/Home/binding/signed_copy_binding.dart';
import 'package:storysign/features/reader/Home/binding/upload_book_binding.dart';
import 'package:storysign/features/reader/Home/binding/view_all_books_binding.dart';

import 'package:storysign/features/reader/Home/controller/request_autograph_controller.dart';

import 'package:storysign/features/reader/Home/view/make_payment.dart';
import 'package:storysign/features/reader/Home/view/request_detail.dart';
import 'package:storysign/features/reader/Home/view/signed_copy.dart';
import 'package:storysign/features/reader/Home/view/tracking_screen.dart';
import 'package:storysign/features/reader/Home/view/upload_book.dart';
import 'package:storysign/features/reader/Home/view/view_all_books.dart';
import 'package:storysign/features/reader/library/controller/library_detail_controller.dart';
import 'package:storysign/features/reader/library/binding/library_detail_binding.dart';
import 'package:storysign/features/reader/library/binding/reader_library_binding.dart';
import 'package:storysign/features/reader/profile/binding/profile_download_history_binding.dart';
import 'package:storysign/features/reader/profile/binding/profile_view_all_books_binding.dart';
import 'package:storysign/features/reader/profile/view/profile_download_history.dart';
import 'package:storysign/features/reader/profile/view/profile_view_all_books.dart';

import 'package:storysign/features/shared/changePassword/binding/change_password_binding.dart';
import 'package:storysign/features/shared/contactUs/binding/contact_us_binding.dart';
import 'package:storysign/features/shared/editProfile/binding/edit_profile_binding.dart';
import 'package:storysign/features/reader/profile/binding/help_support_binding.dart';
import 'package:storysign/features/reader/profile/binding/privacy_policy_binding.dart';
import 'package:storysign/features/reader/profile/binding/profile_binding.dart';

import 'package:storysign/features/shared/changePassword/view/change_password.dart';
import 'package:storysign/features/shared/contactUs/view/contact_us.dart';
import 'package:storysign/features/shared/editProfile/view/edit_profile.dart';
import 'package:storysign/features/reader/profile/view/help_and_support.dart';
import 'package:storysign/features/reader/profile/view/privacy_policy.dart';
import 'package:storysign/features/reader/profile/view/profile_screen.dart';

import 'package:storysign/features/reader/search/binding/search_binding.dart';

import '../../features/author/bottomNav/view/author_bottom_nav_layout.dart';import 'package:storysign/features/author/delivered/binding/delivered_binding.dart';
import 'package:storysign/features/author/delivered/view/delivered_screen.dart';import '../../features/author/request/binding/request_detail_binding.dart';
import '../../features/author/request/view/request_detail.dart';
import '../../features/author/subscriptionplan/view/subscription_plan_selection.dart';

import '../../features/reader/Home/binding/reader_request_detail_binding.dart';
import '../../features/reader/Home/binding/tracking_binding.dart';
import '../../features/reader/Home/view/request_autograph.dart';
import '../../features/reader/Home/view/select_author.dart';
import '../../features/reader/Home/view/track_request.dart';

import '../../features/reader/bottomNav/binding/bottom_nav_binding.dart';
import '../../features/reader/bottomNav/view/bottom_nav_layout.dart';
import '../../features/reader/library/view/reader_library.dart';
import '../../features/reader/library/view/reader_library_detail.dart';

import '../../features/reader/search/view/author_detail.dart';
import '../../features/reader/search/view/request_autograph.dart';
import '../../features/shared/auth/binding/auth_binding.dart';
import '../../features/shared/auth/view/choose_role.dart';
import '../../features/shared/auth/view/forgot_password/resend_otp.dart';
import '../../features/shared/auth/view/forgot_password/reset_password.dart';
import '../../features/shared/auth/view/forgot_password/send_otp.dart';
import '../../features/shared/auth/view/sign_in.dart';
import '../../features/shared/auth/view/sign_up.dart';
import '../../features/shared/auth/view/onboarding.dart';
import '../../features/shared/auth/view/splash_screen.dart';


class AppRoutes {
  static List<GetPage<dynamic>> routes = [
    GetPage(name: '/', page: () => const SplashScreen(), binding: AuthBinding()),
    GetPage(name: '/onboarding', page: () => const OnBoardingScreen(), binding: AuthBinding()),

    GetPage(name: '/signin', page: () => SignIn(), binding: AuthBinding()),
    GetPage(name: '/signup', page: () => SignUp(), binding: AuthBinding()),

    GetPage(
      name: '/reset',
      page: () => ResetPassword(),
      binding: AuthBinding(),
    ),
    GetPage(name: '/sendotp', page: () => SendOtp(), binding: AuthBinding()),

    GetPage(
      name: '/resendotp',
      page: () => ResendOtp(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: '/chooserole',
      page: () => ChooseRole(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: '/bottomnav',
      page: () => MyBottomBarScreen(),
      binding: BottomNavBinding(),
    ),
    GetPage(
      name: '/trackrequest',
      page:
          ()

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

    GetPage(
      name: '/readerlibrary',
      page: () => ReaderLibrary(),
      binding: ReaderLibraryBinding(),
    ),

    GetPage(
      name: '/requestautograph',
      page: () => RequestAutograph(),
      binding: RequestAutographBinding(),
    ),
    GetPage(
      name: '/readerlibrarydetail',
      page: () => const ReaderLibraryDetailScreen(),
      binding: ReaderLibraryDetailBinding(),
    ),
    //
    // GetPage(
    //   name: '/notification',
    //   page: () => NotificationScreen(),
    //   bindings:[ NotificationBinding() ,AuthorNotificationBinding()],
    // ),

    GetPage(
      name: '/requestautographcard',
      page: () => RequestAutographCard(),
      binding: BindingsBuilder(() {
        Get.lazyPut<RequestAutographController>(() => RequestAutographController());
        Get.lazyPut<ReaderLibraryDetailController>(() => ReaderLibraryDetailController());
      }),
    ),

    GetPage(
      name: '/uploadbook',
      page: () => UploadBook(),
      binding: UploadBookBinding(),
    ),

    GetPage(
      name: '/selectauthor',
      page: () => SelectAuthor(),
      binding: SelectAuthorBinding(),
    ),
    GetPage(
      name: '/request',
      page: () => RequestDetail(),
      bindings: [ReaderRequestDetailBinding(), PaymentBinding()],
    ),
    GetPage(
      name: '/makepayment',
      page: () => MakePayment(),
      binding: PaymentBinding(),
    ),

    // GetPage(
    //   name: '/finalreview',
    //   page: () => FinalReview(),
    //   binding: PaymentBinding(),
    // ),

    GetPage(
      name: '/tracking',
      page: () => TrackingScreen(),
      binding: TrackingBinding(),
    ),

    GetPage(
      name: '/signedcopy',
      page: () => SignedCopy(),
      binding: SignedCopyBinding(),
    ),

    GetPage(
      name: '/viewallbooks',
      page: () => ViewAllBooksScreen(),
      binding: ViewAllBooksBinding(),
    ),
    GetPage(
      name: '/profile',
      page: () => ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: '/profileviewallbooks',
      page: () => ProfileViewAllBooksScreen(),
      binding: ProfileViewAllBooksBinding(),
    ),
    GetPage(
      name: '/profiledownloadhistory',
      page: () => ProfileDownloadHistoryScreen(),
      binding: ProfileDownloadHistoryBinding(),
    ),
    GetPage(
      name: '/editprofile',
      page: () => EditProfile(),
      bindings: [EditProfileBinding(), AuthorProfileBinding()],
    ),

    GetPage(

      name: '/helpandsupport',
      page: () => HelpAndSupport(),
      bindings: [HelpSupportBinding(),AuthorHelpSupportBinding()],
    ),
    GetPage(
      name: '/newpass',
      page: () => ChangePassword(),
      binding: ChangePasswordBinding(),
    ),

    GetPage(
      name: '/contact',
      page: () => ContactUs(),
      binding: ContactUsBinding(),
    ),
    GetPage(
      name: '/privacy',
      page: () => PrivacyPolicy(),
      binding: PrivacyPolicyBinding(),
    ),

    GetPage(
      name: '/authorbottomnav',
      page: () => AuthorBottomNavLayout(),
      binding: AuthorBottomNavBinding(),
    ),

    GetPage(
      name: '/plan',
      page: () => SubscriptionPlan(),
      binding: SubscriptionPlanBinding(),
    ),
    GetPage(
      name: '/selectplan',
      page: () => SubscriptionPlanSelectionScreen(),
      binding: StripePaymentBinding(),
    ),

    GetPage(
      name: '/allRequest',
      page: () => const AllRequest(),
      binding: RequestBinding(),
    ),
    GetPage(
      name: '/deliveredRequest',
      page: () => const DeliveredScreen(),
      binding: DeliveredBinding(),
    ),

    GetPage(
      name: '/requestDetail',
      page: () => RequestDetailAuthor(),
      binding: AuthorRequestDetailBinding(),
    ),

    GetPage(
      name: '/pdfReview',
      page: () => BookPreviewPage(),
      binding: EbookPreviewBinding(),
    ),
    GetPage(
      name: '/drawSignature',
      page: () => const DrawSignatureScreen(),
      binding: DrawSignatureBinding(),
    ),

    GetPage(
      name: '/placeSignature',
      page: () => const PlaceSignatureScreen(),
      binding: PlaceSignatureBinding(),
    ),
    GetPage(
      name: '/authorFinalReview',
      page: () => const FinalReviewScreen(),
      binding: AuthorFinalReviewBinding(),
    ),
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
