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
  final TextEditingController confirmPasswordController =
  TextEditingController();

  final TextEditingController signInEmailController = TextEditingController();
  final TextEditingController signInpasswordController =
  TextEditingController();

  final TextEditingController forgotEmailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
  TextEditingController();

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
    // fullNameController.dispose();
    // emailController.dispose();
    // passwordController.dispose();
    // signInEmailController.dispose();
    // signInpasswordController.dispose();
    // otpController.dispose();
    // newPasswordController.dispose();
    // confirmNewPasswordController.dispose();
    // confirmPasswordController.dispose();
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
      final fileName =
          'profile_image_${DateTime.now().millisecondsSinceEpoch}.png';
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
    final String fullName = fullNameController.text.trim();
    String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();

    if (fullName.isEmpty) {
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

      final uri = Uri.parse(
        '${BaseService().baseURL}${ApiEndPoints.signupUser}',
      );
      final request = http.MultipartRequest('POST', uri);

      request.fields['fullName'] = fullName;
      request.fields['email'] = email;

      request.fields['role'] = role!;
      request.fields['password'] = password;
      request.fields['confirmPassword'] = confirmPassword;

      if (role.toLowerCase() == 'author') {
        request.fields['bio'] = bioController.text
            .trim(); // Yahan apna bio controller use karein
      }

      final File? currentProfileImage = profileImage.value;
      if (currentProfileImage != null && currentProfileImage.existsSync()) {
        final fileName = currentProfileImage.path.split('/').last;
        request.files.add(
          await http.MultipartFile.fromPath(
            'profilePicture',
            currentProfileImage.path,
            filename: fileName,
            contentType: MediaType('image', 'png'),
          ),
        );
      }

      print('⏳ SIGNUP API CALLING: $uri');
      print('➡ Fields: ${request.fields}');

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      );
      final responseString = await streamedResponse.stream.bytesToString();
      final responseMap = json.decode(responseString);

      print('✅ RESPONSE: $responseMap');

      if (streamedResponse.statusCode == 201) {
        Utils.showToast(responseMap['message'] ?? 'Signup successful', false);
        clearSignUpFeild();
        final data = responseMap['user'];
        if (data != null && data['email'] != null) {
          email = data['email'];
        }

        final dynamic dataValue = responseMap['data'] ?? responseMap;
        final Map<String, dynamic>? dataMap = dataValue is Map<String, dynamic>
            ? dataValue
            : null;
        final Map<String, dynamic>? user =
        responseMap['user'] is Map<String, dynamic>
            ? responseMap['user'] as Map<String, dynamic>
            : (dataMap != null && dataMap['user'] is Map<String, dynamic>
            ? dataMap['user'] as Map<String, dynamic>
            : null);
        final String? token =
            responseMap['accessToken'] as String? ??
                dataMap?['accessToken'] as String?;

        if (user == null || token == null) {
          Utils.showToast('Invalid server response', true);
          return;
        }

        final prefsInstance = await SharedPreferences.getInstance();

        await prefsInstance.setString(LocalDBKeys.USERDATA, jsonEncode(user));

        final prefs = SharedPreferencesMethod.storage;
        await prefsInstance.setString(LocalDBKeys.TOKEN, token);
        await prefs.setString(LocalDBKeys.USERFULLNAME, user['fullName'] ?? "");
        final String? refreshToken = responseMap['refreshToken'] as String? ??
            dataMap?['refreshToken'] as String?;

        await prefs.setString(LocalDBKeys.REFRESH_TOKEN, refreshToken ?? "");
        final String role = user['role']?.toString().toLowerCase() ?? 'reader';

        await prefsInstance.setString('role', role);

        final redirectRoute = role.toLowerCase() == 'author'
            ? '/plan'
            : '/bottomnav';

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

  void clearSignUpFeild() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  //---------------------------------------------------------------------------------------//
  //login//
  Future<void> login() async {
    final String email = signInEmailController.text.trim();
    final String password = signInpasswordController.text.trim();

    if (email.isEmpty) {
      Utils.showToast('Email is required', true);
      return;
    }
    if (password.isEmpty) {
      Utils.showToast('Password is required', true);
      return;
    }

    try {
      final payload = {'email': email, 'password': password};

      final responseMap = await BaseService().basePostAPI(
        ApiEndPoints.loginUser,
        payload,
      );

      debugPrint('⏳ LOGIN RESPONSE: $responseMap');

      final String? successMessage = responseMap['message']?.toString();
      final String errorMessage =
          responseMap['message']?.toString() ?? 'Login failed';

      if (responseMap['success'] != true) {
        // basePostAPI already error toast dikha chuka hoga is case mein
        return;
      }

      final dynamic dataValue = responseMap['data'] ?? responseMap;
      final Map<String, dynamic>? dataMap = dataValue is Map<String, dynamic>
          ? dataValue
          : null;
      final Map<String, dynamic>? user =
      responseMap['user'] is Map<String, dynamic>
          ? responseMap['user'] as Map<String, dynamic>
          : (dataMap != null && dataMap['user'] is Map<String, dynamic>
          ? dataMap['user'] as Map<String, dynamic>
          : null);
      final String? token =
          responseMap['accessToken'] as String? ??
              dataMap?['accessToken'] as String?;

      if (user == null || token == null) {
        Utils.showToast('Invalid server response', true);
        return;
      }

      final prefs = SharedPreferencesMethod.storage;
      await prefs.setString(LocalDBKeys.USERDETAIL, jsonEncode(user));
      await prefs.setString(LocalDBKeys.USERID, user['id'] ?? "");
      await prefs.setString(LocalDBKeys.USERFULLNAME, user['fullName'] ?? "");
      await prefs.setString(LocalDBKeys.TOKEN, token);
      final String? refreshToken = responseMap['refreshToken'] as String? ??
          dataMap?['refreshToken'] as String?;

      await prefs.setString(LocalDBKeys.REFRESH_TOKEN, refreshToken ?? "");
      await prefs.setBool('isLoggedIn', true);
      Utils.showToast(successMessage ?? 'Login successful', false);

      clearLoginFeilds();
      final String role = user['role']?.toString().toLowerCase() ?? 'reader';

      await prefs.setString('role', role);
      if (role == 'author') {
        Get.offAllNamed('/authorbottomnav');
      } else {
        Get.offAllNamed('/bottomnav');
      }
    } catch (e) {
      debugPrint('Login error: $e');
      Utils.showToast('Something went wrong. Please try again.', true);
    }
  }

  void clearLoginFeilds() {
    signInEmailController.clear();
    signInpasswordController.clear();
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

    if (!email.contains('@')) {
      Utils.showToast('Please enter a valid email', true);
      return;
    }

    try {
      // 2. API Call
      final response = await BaseService().basePostAPI(
        ApiEndPoints.forgotPassword,
        {'email': email},
      );

      if (response['success'] == true) {
        Utils.showToast(
          response['message'] ?? 'Reset link sent to your email',
          false,
        );

        Get.toNamed("/resendotp");
        // Get.toNamed('/sendotp', arguments: {'email': email});
      }
      // basePostAPI already error toast dikha chuka hai — dobara mat lagao
    } catch (e) {
      debugPrint('Forgot Password Error: $e');
      Utils.showToast('Something went wrong', true);
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
      final response = await BaseService().basePostAPI(ApiEndPoints.verifyOtp, {
        'email': email,
        'code': otp,
      });

      if (response['success'] == true) {
        Utils.showToast(response['message'] ?? 'OTP Verified', false);

        Get.toNamed('/resendotp', arguments: {'email': email, 'code': otp});
      }
      // basePostAPI already error toast dikha chuka hai — dobara mat lagao
    } catch (e) {
      debugPrint('verifyOtp error: $e');
      Utils.showToast('Error: $e', true);
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
      final response = await BaseService()
          .basePostAPI(ApiEndPoints.resetPassword, {
        'email': email,
        'code': code,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      });

      if (response['success'] == true) {
        Utils.showToast(
          response['message'] ?? 'Password reset successful',
          false,
        );

        Get.offAllNamed('/login');
        clearResetPasswordFeilds();
      }
    } catch (e) {
      debugPrint('resetPassword error: $e');
      Utils.showToast('Something went wrong', true);
    }
  }

  void clearResetPasswordFeilds() {
    newPasswordController.clear();
    confirmNewPasswordController.clear();
  }
}