import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefServices {
  static SharedPreferences? prefs;

  static Future<void> clearUserFromSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();

    await prefs!.setString(_keyloginId, '');
    await prefs!.setString(_keymobileNumber, '');
    await prefs!.setString(_keysessionToken, '');
    await prefs!.setString(_keyfirstName, '');
    await prefs!.setString(_keylastName, '');
    await prefs!.setString(_keygender, '');
    await prefs!.setString(_keydisplayname, '');
    await prefs!.setBool(_keyisLoggedIn, false);
    await prefs!.setBool(_keyisDarkmode, false);
  }

  static const _keyloginId = 'loginId';
  static const _keymobileNumber = 'mobileNumber';
  static const _keysessionToken = 'sessionToken';
  static const _keyisLoggedIn = 'isLoggedIn';
  static const _keyisDarkmode = 'isDarkmode';
  static const _keyfirstName = 'firstName';
  static const _keylastName = 'lastName';
  static const _keygender = 'gender';
  static const _keydisplayname = 'displayname';

  static Future init() async => prefs = await SharedPreferences.getInstance();

  static Future setloginId(String loginId) async =>
      await prefs!.setString(_keyloginId, loginId);
  static Future setmobileNumber(String mobileNumber) async =>
      await prefs!.setString(_keymobileNumber, mobileNumber);
  static Future setsessionToken(String sessionToken) async =>
      await prefs!.setString(_keysessionToken, sessionToken);
  static Future setfirstName(String firstName) async =>
      await prefs!.setString(_keyfirstName, firstName);
  static Future setlastName(String lastName) async =>
      await prefs!.setString(_keylastName, lastName);
  static Future setgender(String gender) async =>
      await prefs!.setString(_keygender, gender);
  static Future setdisplayname(String displayname) async =>
      await prefs!.setString(_keydisplayname, displayname);

  static Future setisLoggedIn(bool isLoggedIn) async =>
      await prefs!.setBool(_keyisLoggedIn, isLoggedIn);
  static Future setisDarkmode(bool isDarkmode) async =>
      await prefs!.setBool(_keyisDarkmode, isDarkmode);

// getters

  static String? getloginId() => prefs!.getString(_keyloginId);
  static String? getmobileNumber() => prefs!.getString(_keymobileNumber);
  static String? getsessionToken() => prefs!.getString(_keysessionToken);
  static String? getfirstName() => prefs!.getString(_keyfirstName);
  static String? getlastName() => prefs!.getString(_keylastName);
  static String? getgender() => prefs!.getString(_keygender);
  static String? getdisplayname() => prefs!.getString(_keydisplayname);
  static bool? getisLoggedIn() => prefs!.getBool(_keyisLoggedIn) ?? false;
  static bool? getisDarkmode() => prefs!.getBool(_keyisDarkmode) ?? false;
}
