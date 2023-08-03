


import 'package:thanhhoa_garden_staff_app/models/store/store.dart';
import 'package:thanhhoa_garden_staff_app/utils/connection/utilsConnection.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../../models/authentication/user.dart';
import '../../utils/helper/shared_prefs.dart';

Future <Store> FetchInfoMyStore (id) async {
  String url = '$mainURL${storeIdURL}storeID=$id';
  final response = await http.get(
    Uri.parse(url),
    headers: headerLogin,
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    print (response.body);
    final decoded = utf8.decode(response.bodyBytes); // Giải mã với UTF-8
    final data = jsonDecode(decoded);
    print('Success GetInfo');
    return Store.fromJson(data);
  }
  else if (response.body.isEmpty) {
    throw Exception('Empty response body');
  }
  else {
    throw Exception('Đã có lỗi: ${response.statusCode}');
  }
}

Future <String> FetchMyStoreID () async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  String url = '$mainURL$getUserInfoURL';
  final response = await http.get(
    Uri.parse(url),
    headers: header,
  );
  print("FetchMyStoreID");
  if (response.statusCode == 200) {
    return response.body;
  }
  else if (response.body.isEmpty) {
    throw Exception('Empty response body');
  }
  else {
    throw Exception('Đã có lỗi: ${response.statusCode}');
  }
}

String FormatStoreID (jsonString) {

  try {
    Map<String, dynamic> data = jsonDecode(jsonString);

    String storeID = data['storeID'];
    return storeID;
  } catch (e) {
    print('This is not a valid JSON.');
  }
  return 'Đang cập nhật';
}