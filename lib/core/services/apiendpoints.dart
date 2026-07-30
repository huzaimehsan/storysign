class ApiEndPoints {
  // Auth

  static const String loginUser = '/auth/login';
  static const String signupUser = '/auth/signup';
  static const String forgotPassword = '/auth/forgot-password';

  static const String verifyOtp = '/auth/forgot-password/verify';
  static const String resetPassword = '/auth/forgot-password/reset';

  static const String verifyForgotOtp = '/auth/verify-forgot-password-otp';

  static const String allAuthor = '/reader/authors?search=';
  static const String authorDetail = '/reader/authors';

  static const String uploadBook = '/reader/books/upload';
  static const String listMyBook = '/reader/library';
  static const String refreshToken = '/auth/refresh';

  static const String requestAutoGraphHome = '/reader/autograph-requests';

  static const String trackRequest =
      '/reader/autograph-requests?page=1&limit=10';

  static String getAutographRequestDetails(String id) {
    return '/reader/autograph-requests/$id';
  }

  static const String verifyPayment =
      "/reader/autograph-requests/confirm-payment";

  static const String contactUs = "/reader/contact";
  static const String changePassword = "/auth/change-password";

  static const String faqs = "/reader/faqs";

  static const String helpSupport = "/reader/help";
  static const String authorHelpSupport = "/author/help";
  static const String authorFaqs = "/author/faqs";
  static const String notifications = "/reader/notifications?page=1&limit=20";

  static const String authorNotifications = "/author/notifications?page=1&limit=20";


  static const String profile = "/reader/profile";

  static const String authorProfile = "/author/profile";
  static const String editProfile = "/reader/profile";
  static const String libraryStats = "/reader/profile/stats";
  static const String bookHistory = "/reader/download-history?page=1&limit=10";
  static const String authorReadAllNotifications = "/author/notifications/read-all";

  static String markNotificationAsRead(String notificationId) {
    return '/reader/notifications/$notificationId/read';
  }

  static String downloadBook(String bookId) {
    return '/reader/downloads/$bookId';
  }

  /// author apis

  static const String planType = "/author/subscription/plans";
  static const String checkOutPayment = "/author/subscription/checkout";

  static String confirmSubscriptionPayment =
      '/author/subscription/confirm-payment';
  static const String authorStats = "/author/stats";
  static const String readerStripePayment =
      "/reader/autograph-requests/confirm-payment";

  static const String readerVerifyPayment = "/payments/verify-success";
  static const String currentSubscription = "/author/subscription/current";

 static String pendingRequest({int page = 1, int limit = 10}) =>
    "/author/requests/pending?page=$page&limit=$limit";

   
static String deliveryRequest({int page = 1, int limit = 10}) =>
    "/author/requests/delivered?page=$page&limit=$limit";

  static String autographRequestDetails(String autographRequestId) {
    return "/author/requests/$autographRequestId";
  }

  static String acceptAutographRequest(String autographRequestId) {
    return "/author/requests/$autographRequestId/accept";
  }

  static String rejectAutographRequest(String autographRequestId) {
    return "/author/requests/$autographRequestId/reject";
  }

  static String approveSendAutographRequest(String autographRequestId) {
    return "/author/requests/$autographRequestId/approve-send";
  }

  static String listMyBooks({int page = 1, int limit = 10}) {
    return "/reader/library?page=$page&limit=$limit&status=signed";
  }


  static const String registerReaderFcmToken = '/reader/fcm-token';
  static const String removeReaderFcmToken = 'reader/fcm-token/remove';
}

// //Vehical
// static const String getVehicles = '/fleet/vehicles?search=';
// static const String getEquipment = '/fleet/equipment?search=';
//
// static String delteVehical (String vehicalId){
//   return "/fleet/vehicles/${vehicalId}";
// }
// static String delteEquipment (String equipmentId){
//   return "/fleet/equipment/${equipmentId}";
// }
//
// static String updateVehicle (String vehicleId){
//   return "/fleet/vehicles/${vehicleId}";
// }
//
// static String updateEquipment (String equipmentId){
//   return "/fleet/equipment/${equipmentId}";
// }
// //Profile
// static const String changePassword = '/auth/change-password';
// static const String updateProfile = '/users/profile';
