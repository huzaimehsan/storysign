// // import 'dart:ffi';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../constants/customText_widget.dart';
//
// // import 'package:intl/intl.dart';
// // import 'package:resilient/components/custom_text.dart';
// // import 'package:resilient/components/custom_toast.dart';
// // import 'package:resilient/Utils/text_constants.dart';
//
//
// // import 'local_db_key.dart';
//
// class HelperFunction {
//   static String? emailValidate(String val) {
//     if (val.isEmpty) {
//       return 'Email cannot be empty';
//     } else if (val.isEmail == false) {
//       return 'Invalid email';
//     } else {
//       return null;
//     }
//   }
//
//   static String? stringValidate(val, {fieldName}) {
//     if (val.isEmpty || val == '') {
//       return '${fieldName ?? 'Field'} cannot be empty';
//     } else {
//       return null;
//     }
//   }
//
//   // static Future<void> openUrl(String url) async {
//   //   if (!await launchUrl(Uri.parse(url))) {
//   //     throw Exception('Could not launch $url');
//   //   }
//   // }
//
//   // static String formatDateString(String dateString) {
//   //   try {
//   //     // Parse the date string into a DateTime object
//   //     DateTime date = DateTime.parse(dateString);
//
//   //     // Format the DateTime object as "June 18, 2023"
//   //     String formattedDate = DateFormat.yMMMd().format(date);
//   //     print(formattedDate);
//   //     return formattedDate;
//   //   } catch (e) {
//   //     // Handle any parsing errors here
//   //     return 'Invalid Date';
//   //   }
//   // }
//
//   // static String formatTimeFromISOString(String dateTimeString) {
//   //   try {
//   //     // Parse the ISO 8601 date string into a DateTime object
//   //     DateTime dateTime = DateTime.parse(dateTimeString);
//
//   //     // Format the DateTime object as "1:00 PM"
//   //     String formattedTime = DateFormat('h:mm a').format(dateTime.toLocal());
//   //     print(formattedTime);
//   //     return formattedTime;
//   //   } catch (e) {
//   //     // Handle any parsing errors here
//   //     return 'Invalid Date';
//   //   }
//   // }
//
//   // static String? ValidateName(val, {fieldName}) {
//   //   final alphanumeric = RegExp(r'^[a-zA-Z\s]+$');
//   //   if (val.isEmpty || val == '') {
//   //     return '${fieldName ?? 'Field'} cannot be empty';
//   //   }else if (!alphanumeric.hasMatch(val)) {
//   //     return 'Special characters not allowed';
//   //   } else {
//   //     return null;
//   //   }
//   // }
//
//   static String? ValidateName(String val, {String? fieldName}) {
//     final alphanumeric = RegExp(r'^[a-zA-Z\s]+$');
//
//     if (val.isEmpty || val == '') {
//       return '${fieldName ?? 'Field'} cannot be empty';
//     } else if (!alphanumeric.hasMatch(val)) {
//       if (val.contains(RegExp(r'[0-9]'))) {
//         return 'Numeric characters not allowed';
//       } else {
//         return 'Special characters not allowed';
//       }
//     } else {
//       return null;
//     }
//   }
//
//   static String? validateQR(String val, {String? fieldName}) {
//     final specialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
//     final alphanumericWithNumbers = RegExp(r'^[a-zA-Z0-9\s]+$');
//
//     if (val.isEmpty || val == '') {
//       return '${fieldName ?? 'Field'} cannot be empty';
//     } else if (specialCharacters.hasMatch(val)) {
//       return 'Special characters not allowed';
//     } else if (!alphanumericWithNumbers.hasMatch(val)) {
//       return 'Invalid characters';
//     } else {
//       return null;
//     }
//   }
//
//   static String? stringValidateWithLImit(val, limit, {fieldName}) {
//     if (val.isEmpty || val == '') {
//       return '${fieldName ?? 'Field'} cannot be empty';
//     } else if (val.toString().length > limit) {
//       return 'Character limit exceeded';
//     } else {
//       return null;
//     }
//   }
//
//   static String? bloodTarget(val, val2, limit, msg) {
//     print('arso val $val2');
//     if (val2.isEmpty || val2 == null) {
//       val2 = 0;
//     }
//     if (val == null || val == '') {
//       return 'Field cannot be empty';
//     } else if (val.toString().length > limit) {
//       return 'Character limit exceeded';
//     } else if (int.parse(val.toString()) > int.parse(val2.toString())) {
//       return msg;
//     } else if (int.parse(val.toString()) == int.parse(val2.toString())) {
//       return msg;
//     } else {
//       return null;
//     }
//   }
//
//   static String? bloodTargetHigh(val, val2, limit, msg) {
//     print('arso val $val2');
//     if (val2.isEmpty || val2 == null) {
//       val2 = 0;
//     }
//     if (val == null || val == '') {
//       return 'Field cannot be empty';
//     } else if (val.toString().length > limit) {
//       return 'Character limit exceeded';
//     } else if (int.parse(val.toString()) < int.parse(val2.toString())) {
//       return msg;
//     } else if (int.parse(val.toString()) == int.parse(val2.toString())) {
//       return msg;
//     } else {
//       return null;
//     }
//   }
//
//   static String? ValidateLog(val, limit, highval, {fieldName}) {
//     if (val.isEmpty || val == '') {
//       return '${fieldName ?? 'Field'} cannot be empty';
//     } else if (val.toString().length > limit) {
//       return 'Character limit exceeded';
//     } else if (val > highval) {
//       return 'must be less then high value';
//     } else {
//       return null;
//     }
//   }
//
//   // static String? passwordValidate(String value,{String? msg}) {
//   //   if (value.isEmpty || value == "") {
//   //     return '${msg ?? "Password cannot be empty"}';
//   //   }
//   //   if (value.length < 8) {
//   //     return "Password is really short please enter at least 8 character.";
//   //   } else {
//   //     return null;
//   //   }
//   // }
//
//   static bool showPassword(bool value) {
//     if (value == true) {
//       return false;
//     } else {
//       return true;
//     }
//   }
//
//   static void showBottomSheet(context,
//       {double? bottomSheetHeight,
//       double? spaceBetween,
//       String? screenTitle,
//       Widget? save,
//       Widget? widget}) {
//     showModalBottomSheet(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//               topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0)),
//         ),
//         context: context,
//         builder: (BuildContext bc) {
//           return Padding(
//             padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
//             child: Container(
//               height: bottomSheetHeight ?? 300,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       GestureDetector(
//                           onTap: () {
//                             Get.back();
//                           },
//                           child: customText(
//                             text: '${'Constants_Cancel'.tr}',
//                             fontSize: 13,
//                             color: Color(0xff89889B),
//                           )),
//                       customText(text: '${screenTitle ?? 'Screen Name'}'),
//                       if (save == null)
//                         Container(
//                           width: 30,
//                         ),
//                       if (save != null) save
//                     ],
//                   ),
//                   SizedBox(
//                     height: spaceBetween ?? 20,
//                   ),
//                   Expanded(child: widget ?? Container()),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//
//   static Future<void> clearLocalStorage() async {
//     SharedPreferences storage = await SharedPreferences.getInstance();
//     storage.clear();
//   }
//
//   static String? passwordValidate(String password, {String? msg}) {
//     print(password);
//
//     if (password == "" || password.isEmpty) {
//       return '${msg ?? "Password cannot be empty"}';
//       // return "Password field cannot be empty";
//     }
//
//     bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
//     if (!hasUppercase) {
//       return "must contains at least 1 upper case letter";
//     }
//     bool hasDigits = password.contains(new RegExp(r'[0-9]'));
//     if (!hasDigits) {
//       return "must contains at least 1 digit";
//     }
//     bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
//     if (!hasLowercase) {
//       return "must contains at least 1 lower case letter";
//     }
//     bool hasSpecialCharacters =
//         password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
//     if (!hasSpecialCharacters) {
//       return 'must contains at least 1 special character';
//     }
//     bool hasMinLength = password.length >= 7;
//     if (!hasMinLength) {
//       return "Your password must be 7 characters or more";
//     }
//
//     return null;
//   }
//
//   // static String getFormatedMonthDate(date){
//   //   String formattedDate = DateFormat('MMMM').format(date);
//   //   return formattedDate;
//   // }
//
//   // static Future<LocationResult?> navigateToLocationPicker(BuildContext context, {LatLng? latLng}) async {
//   //   try {
//   //     LocationResult? result = await Navigator.of(context).push(
//   //       MaterialPageRoute(
//   //         builder: (context) => PlacePicker(
//   //           'AIzaSyCtin-ww3QMlwxB_658TuAUV9r4XId0kEw',
//   //           displayLocation: latLng,
//   //         ),
//   //       ),
//   //     );
//
//   //     // Handle the result in your way
//   //     print('arso result $result');
//   //     print(result);
//
//   //     return result;
//   //   } catch (e) {
//   //     // showLocationPermissionDialog(context, () {
//   //     //   Navigator.pop(context);
//   //     // });
//   //     // SnackBarUtil.errorSnackBar(context: context, message: "Data not found. Turn on your device's location!");
//   //     print("Error getting location $e");
//   //   }
//   // }
// }
