import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../utils/connection/utilsConnection.dart';
import '../../utils/helper/shared_prefs.dart';
import 'model/report.dart';

Future createReport (des, contractDetailID) async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  final response = await http.post(
    Uri.parse(mainURL + createReportURL),
    headers : header,
    body: jsonEncode({
      "description": "$des",
      "contractDetailID": contractDetailID
    })
  );
  //final responseBody = response.body.toString();
  if (response.statusCode == 200) {
    Fluttertoast.showToast(
        msg: "Đã gửi báo cáo",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  else {
    Fluttertoast.showToast(
        msg: "Gửi báo cáo không thành công",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    throw Exception('Error: ${response.statusCode}');
  }
}

Future<List<Report>> fetchReport() async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  String url = '$mainURL$getReportByToken';

  final response = await http.get(
    Uri.parse(url),
    headers: header,
  );
  final responseJson = jsonDecode(response.body);
  print(responseJson.toString());
  List<Report> reports = [];
  if (response.statusCode == 200) {
    print(response.statusCode.toString());
    if (responseJson is List) {
      reports = responseJson
          .map((json) => Report.fromJson(json as Map<String, dynamic>))
          .toList();
    } else if (responseJson is Map<String, dynamic>) {
      Report report = Report.fromJson(responseJson);

      reports = [report];
    }
    return reports;
  } else {
    throw Exception('Failed to fetch Report');
  }
}