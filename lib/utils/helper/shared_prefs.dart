
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
List<Map<String, dynamic>> getListContactDetailFromSharedPrefs() {
  if (sharedPreferences.getString('ContactDetail') == null) {
    return [];
  } else {
    List<Map<String, dynamic>> list = [];
    var json = jsonDecode(sharedPreferences.getString('ContactDetail')!);
    for (var data in json['detailModelList']) {
      list.add(data);
    }
    return list;
  }
}