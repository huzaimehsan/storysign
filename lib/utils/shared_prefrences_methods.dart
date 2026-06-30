import 'dart:convert';

import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/local_db_key.dart';


class SharedPreferencesMethod {
  static var storage = Get.find<SharedPreferences>();

  static Future<void> clearLocalStorage() async {
    storage.clear();
  }

  static Future<bool> setBool({required String key, required bool value}) async {
    return storage.setBool(key, value);
  }

  static bool getBool({required String key, bool defaultValue = false}) {
    return storage.getBool(key) ?? defaultValue;
  }

  static Future<void> setString(key, value) async {
    storage.setString(key, value);
  }

  static String getString(key) {
    String? a = storage.getString(key);
    return a!;
  }

  static Map getUserInfo() {
    Map data = {
      "token": storage.getString(LocalDBKeys.TOKEN),
      "id": storage.getString(LocalDBKeys.USERID),
      "email": storage.getString(LocalDBKeys.USEREMAIL),
    };
    return data;
  }

  static Future getUserInfo1() async {
    if (SharedPreferencesMethod.storage.getString(LocalDBKeys.USERDETAIL) != null) {
      var a = SharedPreferencesMethod.storage.getString(LocalDBKeys.USERDETAIL);
      return Data.fromJson(jsonDecode(a!));
    } else {
      return null;
    }
  }

  static String? getUserId() {
    return storage.getString(LocalDBKeys.USERID);
  }

  static Future<bool> setUserInfo1(Data user) async {
    return await SharedPreferencesMethod.storage.setString(LocalDBKeys.USERDETAIL, jsonEncode(user));
  }
}
class Data {
  String? id;
  String? email;
  String? token;

  Data({this.id, this.email, this.token});

  // A factory constructor to create a Data object from JSON
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      email: json['email'],
      token: json['token'],
    );
  }

  // A method to convert a Data object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'token': token,
    };
  }
}
