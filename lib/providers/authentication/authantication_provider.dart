// ignore_for_file: library_prefixes, body_might_complete_normally_catch_error

import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../main.dart';
import '../../models/authentication/role.dart';
import '../../models/authentication/user.dart' as UserObj;
import '../../utils/connection/utilsConnection.dart';
import 'package:http/http.dart' as http;
import '../../utils/helper/shared_prefs.dart';

class AuthenticationProvider extends ChangeNotifier {
  UserObj.User? _loggedInUser;

  UserObj.User? get loggedInUser => _loggedInUser;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> login(Map<String, String?> param) async {
    String result = 'Tài khoản hoặc mật khẩu không đúng';
    var body = json.encode(param);
    // String queryString = Uri(queryParameters: param).query;
    try {
      final res = await http.post(
          Uri.parse(mainURL + loginWithUsernamePasswordURL),
          headers: headerLogin,
          body: body);
      if (res.statusCode == 200) {
        var jsondata = json.decode(res.body);
        if (jsondata['role'] == 'Staff') {
          sharedPreferences.clear();
          sharedPreferences.setString('Token', jsondata['token']);
          final fcmToken = await FirebaseMessaging.instance.getToken();
          setfcmToken(fcmToken!);
          notifyListeners();
          result = '';
        } else {
          Fluttertoast.showToast(
              msg: "Tài khoản bạn dùng không có quyền truy cập ứng dụng",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          result = 'Tài khoản không có quyền truy cập';
        }
      } else {
        Fluttertoast.showToast(
            msg: "Đăng nhập thất bại",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on HttpException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }

    return result;
  }

  Future<bool> loginWithGGorPhone(Map<String, String?> param) async {
    bool result = false;
    String queryString = Uri(queryParameters: param).query;
    try {
      final res = await http.post(
          Uri.parse(mainURL + loginWithGGorPhoneURL + queryString),
          headers: headerLogin);
      if (res.statusCode == 200) {
        var jsondata = json.decode(res.body);
        sharedPreferences.setString('Token', jsondata['token']);
        final fcmToken = await FirebaseMessaging.instance.getToken();
        setfcmToken(fcmToken!);
        notifyListeners();
        result = true;
      } else {
        Fluttertoast.showToast(
            msg: "Đăng nhập thất bại",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on HttpException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }

    return result;
  }

  Future<bool> getUserInfor() async {
    bool result = false;
    try {
      // print('Token user: ' + getTokenAuthenFromSharedPrefs());
      var header = getheader(getTokenAuthenFromSharedPrefs());
      final res =
      await http.get(Uri.parse(mainURL + getUserInfoURL), headers: header);
      if (res.statusCode == 200) {
        var jsondata = json.decode(res.body);
        Role role = Role.fromJson(jsondata);
        _loggedInUser = UserObj.User.login(jsondata, role);
        sharedPreferences.setString('User', jsonEncode(jsondata));
        notifyListeners();
        result = true;
      } else {
        Fluttertoast.showToast(
            msg: "Đăng nhập thất bại",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on HttpException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return result;
  }


  Future<bool> setfcmToken(String token) async {
    bool result = false;

    try {
      var header = getheader(getTokenAuthenFromSharedPrefs());
      final res = await http.post(
          Uri.parse('$mainURL$updatefcmTokenURL?fcmToken=${token}'),
          headers: header);
      if (res.statusCode == 200) {
        notifyListeners();
        result = true;
      } else {}
    } on HttpException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return result;
  }

  Future<String?> loginWithGG() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.disconnect().catchError((e) {
      print(e);
    }).onError((error, stackTrace) => null);
    googleSignIn.isSignedIn().then((value) async {
      if (value) {
        await googleSignIn.signOut().onError((error, stackTrace) {
          return null;
        });

        await FirebaseAuth.instance.signOut();
      }
    });
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;
    String? token1 = googleAuth?.idToken.toString().substring(0, 500);
    String? token2 = googleAuth?.idToken
        .toString()
        .substring(500, googleAuth.idToken!.length);
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: "$token1$token2",
    );
    var credent = await FirebaseAuth.instance.signInWithCredential(credential);
    if (credent.user?.uid != null) {
      var user = FirebaseAuth.instance.currentUser;
      return user?.email;
    } else {
      return null;
    }
  }

  Future<String> register(UserObj.User user) async {
    String result = 'faild';
    var data = user.toJson();
    var body = json.encode(data);
    try {
      final res = await http.post(Uri.parse(mainURL + registerURL),
          headers: headerLogin, body: body);
      if (res.statusCode == 200) {
        return result = 'Success';
      } else if (res.statusCode == 400) {
        return result = res.body;
      } else {
        return result = 'faild';
      }
    } on HttpException catch (e) {
      print(e.toString());
    }

    return result;
  }

  void logout() async {
    sharedPreferences.clear();
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn
        .disconnect()
        .catchError((e) {})
        .onError((error, stackTrace) => null);
    googleSignIn.isSignedIn().then((value) async {
      await googleSignIn.signOut().onError((error, stackTrace) => null);
      await FirebaseAuth.instance.signOut();
    });

    _loggedInUser = null;
    notifyListeners();
  }
}
