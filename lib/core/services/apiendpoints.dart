
class ApiEndPoints{
  // Auth
  static const String signupUser = '/auth/signup';
  static const String verifyOtp = '/auth/verify-email';
  static const String resendOtp = '/auth/resend-otp';
  static const String login = '/auth/login';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyForgotOtp = '/auth/verify-forgot-password-otp';
  static const String resetPassword = '/auth/reset-password';
  static const String addVehicle = '/fleet/vehicles';
  static const String addEquipment = '/fleet/equipment';
  static const String getProfile = '/users/me';



  //Vehical
  static const String getVehicles = '/fleet/vehicles?search=';
  static const String getEquipment = '/fleet/equipment?search=';

  static String delteVehical (String vehicalId){
    return "/fleet/vehicles/${vehicalId}";
  }
  static String delteEquipment (String equipmentId){
    return "/fleet/equipment/${equipmentId}";
  }

  static String updateVehicle (String vehicleId){
    return "/fleet/vehicles/${vehicleId}";
  }

  static String updateEquipment (String equipmentId){
    return "/fleet/equipment/${equipmentId}";
  }
  //Profile
  static const String changePassword = '/auth/change-password';
  static const String updateProfile = '/users/profile';

}
