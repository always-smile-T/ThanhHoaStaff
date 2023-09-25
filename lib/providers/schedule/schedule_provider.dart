import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:thanhhoa_garden_staff_app/models/workingDate/working_date.dart';
import '../../models/contract/contractDetail/contract_detail.dart';
import '../../models/workingDate/scheduleToday/schedule_today.dart';
import '../../utils/connection/utilsConnection.dart';
import '../../utils/helper/shared_prefs.dart';
import '../../constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<List<WorkingDate>> fetchSchedule() async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  var token = getTokenAuthenFromSharedPrefs();
  String url = mainURL + getScheduleURL;

  final response = await http.get(
    Uri.parse(url),
    headers: header,
  );
  final responseJson = jsonDecode(response.body);
  if (response.statusCode == 200) {
    List<dynamic> jsonData = responseJson as List<dynamic>;
    List<WorkingDate> schedule = jsonData
        .map((json) => WorkingDate.fromJson(json as Map<String, dynamic>))
        .toList();
    return schedule;
  } else {
    throw Exception('Failed to fetch contract details');
  }
}
Future<List<WorkingInSchedule>> fetchScheduleInWeek(from, to) async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  var token = getTokenAuthenFromSharedPrefs();
  String url = '$mainURL${getWorkingURL}from=$from&to=$to';
  final response = await http.get(
    Uri.parse(url),
    headers: header,
  );
  final decoded = utf8.decode(response.bodyBytes);
  if (response.statusCode == 200) {
    List<WorkingInSchedule> contractDetails = ((jsonDecode(decoded)) as List)
        .map((json) => WorkingInSchedule.fromJson(json as Map<String, dynamic>))
        .toList();
    print("contractDetails nè: ");
    print(contractDetails.first);
    return contractDetails;
  } else {
    throw Exception('Failed to fetch contract details');
  }
}

Future<List<WorkingInSchedule>> fetchScheduleContractDetail(contractDetailD) async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  var token = getTokenAuthenFromSharedPrefs();
  String url = '$mainURL${getWorkingDetailURL}contractDetailID=$contractDetailD&pageNo=0&pageSize=250&sortBy=ID&sortAsc=true';
  final response = await http.get(
    Uri.parse(url),
    headers: header,
  );
  final decoded = utf8.decode(response.bodyBytes);
  if (response.statusCode == 200) {
    List<WorkingInSchedule> contractDetails = ((jsonDecode(decoded)) as List)
        .map((json) => WorkingInSchedule.fromJson(json as Map<String, dynamic>))
        .toList();
    return contractDetails;
  } else {
    throw Exception('Failed to fetch contract details');
  }
}

Future ConfirmWorkingDate (contractDetailID) async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  final response = await http.post(
      Uri.parse(mainURL + confirmWorkingURL + contractDetailID),
      headers : header,
  );
  //final responseBody = response.body.toString();
  if (response.statusCode == 200) {
    Fluttertoast.showToast(
        msg: "Hoàn Tất Việc Này",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: buttonColor,
        textColor: Colors.white,
        fontSize: 16.0);
  } else if (response.body.isEmpty) {
    Fluttertoast.showToast(
        msg: "Đã Có Lỗi Xẩy Ra",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: ErorText,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  else {
    throw Exception('Đã có lỗi: ${response.statusCode}');
  }
}

// tam k dung
Future <bool?> checkWorkingDate(contractDetailID, date) async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  String url = mainURL + '/workingDate/getByWorkingDate?contractDetailID=$contractDetailID&date=$date';
  final response = await http.get(
    Uri.parse(url),
    headers: header,
  );

  if (response.statusCode == 200) {
    if(response.body.isNotEmpty){
      print('co ngay nay');
      return true;
    }
    print('khong co ngay nay');
    return false;
  } else {
    Fluttertoast.showToast(
        msg: "Đã Có Lỗi Xẩy Ra",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: ErorText,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
//check start working

Future checkStartWorking(workingDateID, startWorkingIMG, staffID) async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  String url = '$mainURL/workingDate/v2/addStartWorkingDate?workingDateID=$workingDateID&startWorkingIMG=$startWorkingIMG&staffID=$staffID';
  final response = await http.post(
    Uri.parse(url),
    headers: header,
  );

  if (response.statusCode == 200) {
    Fluttertoast.showToast(
        msg: "Bắt đầu làm việc",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: buttonColor,
        textColor: Colors.white,
        fontSize: 16.0);
  } else {
    Fluttertoast.showToast(
        msg: "Đã Có Lỗi Xẩy Ra",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: ErorText,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

//check End working

Future checkEndWorking(workingDateID, endWorkingIMG, staffID) async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  String url = '$mainURL/workingDate/v2/addEndWorkingDate?workingDateID=$workingDateID&endWorkingIMG=$endWorkingIMG&staffID=$staffID';
  final response = await http.post(
    Uri.parse(url),
    headers: header,
  );

  if (response.statusCode == 200) {
    Fluttertoast.showToast(
        msg: "Kết thúc công việc",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: buttonColor,
        textColor: Colors.white,
        fontSize: 16.0);
  } else {
    Fluttertoast.showToast(
        msg: "Đã Có Lỗi Xẩy Ra",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: ErorText,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
