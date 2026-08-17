import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/custom_toast.dart';
import '../constants/local_db_key.dart';

class Utils{

  static bool validateEmail(String email){
    if(email.isEmpty){
      CustomToast().showToast("Email can not be empty", true);
      return false;
    }else if(!email.isEmail){
      CustomToast().showToast("Email format is not correct", true);
      return false;
    }
    return true;
  }

  static bool validatePassword(String password){
    if(password.isEmpty){
      CustomToast().showToast("Password can not be empty", true);
      return false;
    }else if(password.length<8){
      CustomToast().showToast("Password must be 8 characters long", true);
      return false;
    }
    return true;
  }

  static Future<void> clearLocalStorage() async {
    SharedPreferences storage=await SharedPreferences.getInstance();
    storage.clear();
  }

  static Future<Map> getUserInfo() async {
    SharedPreferences storage=await SharedPreferences.getInstance();
    String? id=storage.getString(LocalDBKeys.USERID);
    String? token=storage.getString(LocalDBKeys.TOKEN);

    return {
      "token": token,
      "id": id,
    };
  }

  // 07: 00 am
  static String timeFormator(date){
    var time = TimeOfDay.fromDateTime(date);
    print(time.hourOfPeriod);
    print(time.minute);
    print(time.period.name);
    return '${time.hourOfPeriod <10 ? '0${time.hourOfPeriod}':time.hourOfPeriod} : ${time.minute < 10 ? '0${time.minute}':time.minute} ${time.period.name}';

  }

  // May 26, 07: 00 am
  static String timeFormatorWithDate( String date){
    var a = DateTime.parse(date);
    var time = TimeOfDay.fromDateTime(a);
    var b = new DateFormat('MMM dd, hh:mm').format(a);
    print(time.hourOfPeriod);
    print(time.minute);
    print(time.period.name);
    return b.toString();
  }

  // May 26, 07: 00 am
  static String timeFormatorWithDate2(String date){
    var a = DateTime.parse(date);
    var time = TimeOfDay.fromDateTime(a);
    var b = new DateFormat('MMM dd, hh:mm aa').format(a);
    return b.toString();
  }

  //07: 00 am
  static String timeFormatorWithDate3(String timeCal){
    var a = "2021-02-06 ${timeCal}";
    var b = DateTime.parse(a);
    // var time = TimeOfDay.fromDateTime(a);
    var c = new DateFormat('hh:mm aa').format(b);
    return c.toString();

  }

  static void hideKeyboard(context) {
    FocusScope.of(context).unfocus();
  }



  static void showToast(String body,bool error){
    CustomToast().showToast(body, error);
  }



  static String getMonth(date){
    DateTime dt = DateTime.parse(date);
    String formattedDate = DateFormat('dd MMM').format(dt);
    return formattedDate;
  }

  static String getFormatedDate(String date){
    print(date);
    DateTime dateTime = DateFormat("dd-MM-yyyy").parse(date);
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDate;
  }

  static String getFormatedDate3(String date){
    print(date);
    DateTime dateTime = DateFormat("dd-MM-yyyy").parse(date);
    String formattedDate = DateFormat('MM dd, yyyy').format(dateTime);
    return formattedDate;
  }

  static String getFormatedDate2(String date){
    print('arso $date');
    DateTime dateTime = DateTime.parse(date);
    print(dateTime);
    String formattedDate = DateFormat('yyyy-MMM-dd').format(dateTime);
    return formattedDate;
  }

// static String relativeTime(date){
//   DateTime dt = DateTime.parse(date);
//   return Jiffy("${dt.year}-${dt.month}-${dt.day}", "yyyy-MM-dd").fromNow();
// }

  // static String getFormatedDate(String date){
  //   print(date);
  //   DateTime dateTime = DateFormat("dd-MM-yyyy").parse(date);
  //   String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  //   return formattedDate;
  // }
}
