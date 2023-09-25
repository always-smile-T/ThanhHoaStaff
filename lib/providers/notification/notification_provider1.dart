import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/notification/notification1.dart';
import '../../utils/connection/utilsConnection.dart';
import '../../utils/helper/shared_prefs.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationModel? _notification;
  List<NotificationModel>? _listNotification = [];

  NotificationModel? get notification => _notification;
  List<NotificationModel>? get list => _listNotification;

  Future<bool> getAllNotification() async {
    bool result = false;
    List<NotificationModel> list = [];

    var header = getheader(getTokenAuthenFromSharedPrefs());
    try {
      final res =
      await http.get(Uri.parse(mainURL + notificationURL), headers: header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          for (var data in jsondata) {
            _notification = NotificationModel.fromJson(data);
            list.add(_notification!);
          }
        }
        _listNotification = list;
        result = true;
        notifyListeners();
      } else {
        result = false;
        notifyListeners();
      }
    } on HttpException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }

    return result;
  }

  Future<bool> checkAllNotification() async {
    bool result = false;
    var header = getheader(getTokenAuthenFromSharedPrefs());
    try {
      final res =
      await http.put(Uri.parse(mainURL + checkReadAllURL), headers: header);
      if (res.statusCode == 200) {
        await getAllNotification();
        result = true;
        notifyListeners();
      } else {
        result = false;
        notifyListeners();
      }
    } on HttpException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }

    return result;
  }
}
