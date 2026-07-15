
class ApiEndPoints{
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
  static const String listMyBook = '/reader/library?page=1&limit=10';

static const String requestAutoGraphHome = '/reader/autograph-requests';

static const String trackRequest = '/reader/autograph-requests?page=1&limit=10';


  static String getAutographRequestDetails(String autographRequestId) {
    return '/reader/autograph-requests/$autographRequestId';
  }


  static const String addEquipment = '/fleet/equipment';
  static const String getProfile = '/users/me';



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

}
