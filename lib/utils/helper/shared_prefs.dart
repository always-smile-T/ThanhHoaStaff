
import 'dart:convert';

import '../../main.dart';import '../../models/authentication/role.dart';

import '../../models/authentication/user.dart';

String getTokenAuthenFromSharedPrefs() {
  if (sharedPreferences.getString('Token') == null) {
    return '';
  }
  return sharedPreferences.getString('Token')!;
}

User getCuctomerIDFromSharedPrefs() {
  Role role = Role();
  User user = User.login(
      jsonDecode(sharedPreferences.getString('User')!) as Map<String, dynamic>,
      role);
  return user;
}
