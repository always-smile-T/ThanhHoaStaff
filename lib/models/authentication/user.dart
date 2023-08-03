// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names


import 'package:thanhhoa_garden_staff_app/models/authentication/role.dart';

import '../../constants/constants.dart';

class User {
  late final userID;
  late final address;
  late final avatar;
  late final email;
  late final fullName;
  late final gender;
  late final password;
  late final phone;
  late final status;
  late final username;
  late Role? role;
  late final storeID;

  User(
      {this.userID,
        this.phone,
        this.status,
        this.username,
        this.address,
        this.password,
        this.avatar,
        this.email,
        this.fullName,
        this.gender,
        this.role,
        this.storeID});

  User.login(Map<String, dynamic> json, Role role) {
    userID = json['userID'];
    address = json['address'];
    avatar = json['avatar'];
    email = json['email'];
    fullName = json['fullName'];
    gender = json['gender'];
    password = json['password'];
    phone = json['phone'];
    status = json['status'];
    username = json['username'];
    storeID = json['storeID'];
    role = role;
  }
  User.fetchInfo(Map<String, dynamic> json) {
    userID = json['userID'];
    address = json['address'];
    email = json['email'];
    fullName = json['fullName'];
    phone = json['phone'];
    avatar = json['avatar'] ?? NoIMG;
    storeID = json['storeID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userID'] = userID;
    data['phone'] = phone;
    data['password'] = password;
    data['username'] = username;
    data['fullName'] = fullName;
    data['gender'] = gender;
    data['address'] = address;
    data['avatar'] = avatar;
    data['email'] = email;
    data['storeID']= storeID;

    return data;
  }
}

