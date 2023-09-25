import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:thanhhoa_garden_staff_app/models/cus/cus.dart';
import '../../models/authentication/user.dart';
import '../../utils/connection/utilsConnection.dart';
import '../../utils/helper/shared_prefs.dart';


Future<List<Cus>?> fetchCusInfor(phone) async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  String url = 'https://thanhhoagarden.herokuapp.com/user/searchCustomer?phone=$phone&pageNo=0&pageSize=1&sortBy=ID&sortTypeAsc=true';
  final response = await http.get(
    Uri.parse(url),
    headers: header,
  );
  print("response.statusCode: " + response.statusCode.toString());
  final decoded = utf8.decode(response.bodyBytes);
  if (response.statusCode == 200) {
    List <Cus> user = ((jsonDecode(decoded)) as List)
        .map((json) => Cus.fromJson(json as Map<String, dynamic>))
        .toList();
  return user;
  }
}
