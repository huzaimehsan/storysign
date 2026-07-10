import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/local_db_key.dart';
import '../../../../core/services/apiendpoints.dart';
import '../../../../core/services/base_services.dart';
import '../../../../utils/shared_prefrences_methods.dart';
import '../../../../utils/utility.dart';
import '../../../../widgets/image_picker.dart';

class AuthController extends GetxController {
  RxInt remainingSeconds = 60.obs;
  RxBool isTimerRunning = false.obs;
  Timer? _timer;

  var selectedRole = 'Reader'.obs;
  RxBool isSelected = false.obs;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final TextEditingController forgotEmailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();

  final TextEditingController otpController = TextEditingController();
  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;
  final Rxn<File> profileImage = Rxn<File>();
  final MediaPickerService _mediaPickerService = MediaPickerService();

  String? email;

  void startTimer() {
    isTimerRunning.value = true;
    remainingSeconds.value = 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        isTimerRunning.value = false;
        timer.cancel();
      }
    });
  }

  void selectRole(String role) {
    selectedRole.value = role;
  }

  void proceed() {
    print("User selected: ${selectedRole.value}");

    if (selectedRole.value == "Reader") {
      Get.toNamed('/signup', arguments: 'reader');
    } else {
      Get.toNamed('/signup', arguments: 'author');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }




  //-------------------------------------------------------------//
  Future<void> pickProfilePicture(BuildContext context) async {
    final File? file = await _mediaPickerService.pickMedia(context);
    if (file != null) {
      await saveProfileImageToLocalStorage(file);
    }
  }

  Future<void> saveProfileImageToLocalStorage(File imageFile) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final fileName = 'profile_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final savePath = '${appDocDir.path}/$fileName';
      final savedImage = await imageFile.copy(savePath);
      await SharedPreferencesMethod.setProfileImagePath(savedImage.path);
      profileImage.value = savedImage;
    } catch (e) {
      print('❌ Error saving image: $e');
    }
  }



 //-----------------------------------------------------------------------------------//
 //signup//
  Future<void> signUp(BuildContext context, {String? role}) async {
    final String fullname = fullNameController.text.trim();
    String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();

    if (fullname.isEmpty) {
      Utils.showToast('Full name is required', true);
      return;
    }

    if (email.isEmpty) {
      Utils.showToast('Email is required', true);
      return;
    }

    if (password.length < 8) {
      Utils.showToast('Password must be at least 8 characters', true);
      return;
    }

    if (confirmPassword.length < 8) {
      Utils.showToast('Confirm Password must be at least 8 characters', true);
      return;
    }

    if (password != confirmPassword) {
      Utils.showToast('Password and Confirm Password do not match', true);
      return;
    }

    try {
      EasyLoading.show(
        status: 'Please wait...',
        maskType: EasyLoadingMaskType.black,
      );

      final uri = Uri.parse('${BaseService().baseURL}${ApiEndPoints.signupUser}');
      final request = http.MultipartRequest('POST', uri);

      request.fields['fullName'] = fullname;
      request.fields['email'] = email;

      request.fields['role'] = role!;
      request.fields['password'] = password;
      request.fields['confirmPassword'] = confirmPassword;

      if (role.toLowerCase() == 'author') {
        request.fields['bio'] = bioController.text.trim(); // Yahan apna bio controller use karein
      }

      final File? currentProfileImage = profileImage.value;
      if (currentProfileImage != null && currentProfileImage.existsSync()) {
        final fileName = currentProfileImage.path.split('/').last;
        request.files.add(await http.MultipartFile.fromPath(
          'profilePicture',
          currentProfileImage.path,
          filename: fileName,
          contentType: MediaType('image', 'png'),
        ));
      }

      print('⏳ SIGNUP API CALLING: $uri');
      print('➡ Fields: ${request.fields}');

      final streamedResponse = await request.send().timeout(const Duration(seconds: 60));
      final responseString = await streamedResponse.stream.bytesToString();
      final responseMap = json.decode(responseString);

      print('✅ RESPONSE: $responseMap');

      if (streamedResponse.statusCode == 201) {
        Utils.showToast(responseMap['message'] ?? 'Signup successful', false);

        final data = responseMap['user'];
        if (data != null && data['email'] != null) {
          email = data['email'];
        }

        final prefsInstance = await SharedPreferences.getInstance();
        await prefsInstance.setString(LocalDBKeys.USERFULLNAME, fullNameController.text.trim());

        final redirectRoute = role.toLowerCase() == 'author'
            ? '/authorbottomnav'
            : '/bottomnav';

        clearSignUpFeild();

        Future.microtask(() {
          Get.offAllNamed(redirectRoute);
        });
        return;
      }

      Utils.showToast(responseMap['message'] ?? 'Signup failed', true);
    } on TimeoutException {
      Utils.showToast('Request timed out', true);
    } on SocketException {
      Utils.showToast('No Internet connection', true);
    } catch (e) {
      print('Error: $e');
      Utils.showToast('Unexpected error: $e', true);
    } finally {
      EasyLoading.dismiss();
    }
  }



  void clearSignUpFeild(){

    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }


  //---------------------------------------------------------------------------------------//
  //login//
  Future<void> login() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty) {
      Utils.showToast('Email is required', true);
      return;
    }
    if (password.isEmpty) {
      Utils.showToast('Password is required', true);
      return;
    }

    try {
      EasyLoading.show(status: 'Please wait...', maskType: EasyLoadingMaskType.black);
      final uri = Uri.parse('${BaseService().baseURL}${ApiEndPoints.loginUser}');
      final payload = {'email': email, 'password': password};

      print('⏳ LOGIN REQUEST: $uri');
      print('⏳ LOGIN PAYLOAD: $payload');

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 60));

      final responseMap = jsonDecode(response.body);
      print('⏳ LOGIN STATUS: ${response.statusCode}');
      print('⏳ LOGIN RESPONSE: $responseMap');

      final String? successMessage = responseMap['message']?.toString();
      final String errorMessage = responseMap['message']?.toString() ?? 'Login failed';
      final bool successResponse = response.statusCode >= 200 && response.statusCode < 300;

      if (!successResponse) {
        Utils.showToast(errorMessage, true);
        return;
      }

      final dynamic dataValue = responseMap['data'] ?? responseMap;
      final Map<String, dynamic>? dataMap = dataValue is Map<String, dynamic> ? dataValue : null;
      final Map<String, dynamic>? user = responseMap['user'] is Map<String, dynamic>
          ? responseMap['user'] as Map<String, dynamic>
          : (dataMap != null && dataMap['user'] is Map<String, dynamic>
          ? dataMap['user'] as Map<String, dynamic>
          : null);
      final String? token = responseMap['accessToken'] as String? ?? dataMap?['accessToken'] as String?;
      // final bool? isVerified = responseMap['isVerified'] as bool? ?? dataMap?['isVerified'] as bool?;

      // if (isVerified == false) {
      //   Utils.showToast(errorMessage, true);
      //   Get.toNamed('verification', arguments: {'email': responseMap['email'] ?? dataMap?['email']});
      //   return;
      // }

      if (user == null || token == null) {
        Utils.showToast('Invalid server response', true);
        return;
      }

      final prefs = SharedPreferencesMethod.storage;
      await prefs.setString(LocalDBKeys.USERDETAIL, jsonEncode(user));
      await prefs.setString(LocalDBKeys.USERID, user['id'] ?? "");
      await prefs.setString(LocalDBKeys.USERFULLNAME, user['fullname'] ?? "");
      await prefs.setString(LocalDBKeys.USEREMAIL, user['email'] ?? "");
      await prefs.setString(LocalDBKeys.PHONENUMBER, user['phone'] ?? "");
      await prefs.setString(LocalDBKeys.USERPROFILEPIC, user['profilePicture'] ?? "");
      await prefs.setString(LocalDBKeys.TOKEN, token);

      Utils.showToast(successMessage ?? 'Login successful', false);
      final String role = user['role']?.toString().toLowerCase() ?? 'reader';
      if (role == 'author') {
        Get.offAllNamed('/authorbottomnav');
      } else {
        Get.offAllNamed('/bottomnav');
      }
      clearLoginFeilds();
    } on TimeoutException {
      Utils.showToast('Request timed out', true);
    } on SocketException {
      Utils.showToast('No Internet connection', true);
    } catch (e) {
      print('Login error: $e');
      Utils.showToast('Something went wrong. Please try again.', true);
    } finally {
      EasyLoading.dismiss();
    }
  }


  void clearLoginFeilds(){

    emailController.dispose();
    passwordController.dispose();
  }


//---------------------------------------------------------------------------//
//forgot Password//
  Future<void> forgotPassword() async {
    final String email = forgotEmailController.text.trim();

    // 1. Validation
    if (email.isEmpty) {
      Utils.showToast('Please enter your email', true);
      return;
    }

    // Basic email regex validation
    if (!email.contains('@')) {
      Utils.showToast('Please enter a valid email', true);
      return;
    }

    try {
      EasyLoading.show(
        status: 'Sending reset link...',
        maskType: EasyLoadingMaskType.black,
      );

      // 2. API Call
      final uri = Uri.parse('${BaseService().baseURL}${ApiEndPoints.forgotPassword}');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      ).timeout(const Duration(seconds: 60));

      final responseMap = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Utils.showToast(responseMap['message'] ?? 'Reset link sent to your email', false);


        Get.toNamed('/sendotp', arguments: {'email': email});

      } else {
        Utils.showToast(responseMap['message'] ?? 'Failed to send reset link', true);
      }

    } on TimeoutException {
      Utils.showToast('Request timed out', true);
    } on SocketException {
      Utils.showToast('No Internet connection', true);
    } catch (e) {
      print('Forgot Password Error: $e');
      Utils.showToast('Something went wrong', true);
    } finally {
      EasyLoading.dismiss();
    }
  }



  //----------------------------------------------------------------------------//
  // Verify OTP Function
  Future<void> verifyOtp(String email) async {
    final String otp = otpController.text.trim();

    if (otp.isEmpty || otp.length < 6) {
      Utils.showToast('Please enter a valid 6-digit code', true);
      return;
    }

    try {
      EasyLoading.show(status: 'Verifying...', maskType: EasyLoadingMaskType.black);

      final uri = Uri.parse('${BaseService().baseURL}${ApiEndPoints.verifyOtp}'); // Yahan apna verify endpoint dein
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'code': otp,
        }),
      ).timeout(const Duration(seconds: 60));

      final responseMap = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Utils.showToast(responseMap['message'] ?? 'OTP Verified', false);

        Get.toNamed('/resendotp', arguments: {'email': email, 'code': otp});

      } else {
        Utils.showToast(responseMap['message'] ?? 'Invalid OTP', true);
      }
    } catch (e) {
      Utils.showToast('Error: $e', true);
    } finally {
      EasyLoading.dismiss();
    }
  }


//----------------------------------------------------------------------------//
// reset password function //
  Future<void> resetPassword(String email, String code) async {
    final String newPassword = newPasswordController.text.trim();
    final String confirmPassword = confirmNewPasswordController.text.trim();

    // Validation
    if (newPassword.length < 8) {
      Utils.showToast('Password must be at least 8 characters', true);
      return;
    }
    if (newPassword != confirmPassword) {
      Utils.showToast('Passwords do not match', true);
      return;
    }

    try {
      EasyLoading.show(status: 'Resetting...', maskType: EasyLoadingMaskType.custom);

      final uri = Uri.parse('${BaseService().baseURL}${ApiEndPoints.resetPassword}');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'code': code,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        }),
      );

      final responseMap = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Utils.showToast(responseMap['message'] ?? 'Password reset successful', false);

        Get.offAllNamed('/login');
      clearResetPasswordFeilds();
      }


      else {
        Utils.showToast(responseMap['message'] ?? 'Reset failed', true);
      }
    } catch (e) {
      Utils.showToast('Something went wrong', true);
    } finally {
      EasyLoading.dismiss();
    }
  }


  void clearResetPasswordFeilds(){

    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
  }


}
