import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:thanhhoa_garden_staff_app/models/workingDate/scheduleToday/schedule_today.dart';
import 'package:thanhhoa_garden_staff_app/models/workingDate/working_date.dart';
import '../../utils/connection/utilsConnection.dart';
import '../../utils/helper/shared_prefs.dart';


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
    print(responseJson);
    return schedule;
  } else {
    throw Exception('Failed to fetch contract details');
  }
}
Future<List<ScheduleToday>> fetchScheduleInWeek(from, to) async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  var token = getTokenAuthenFromSharedPrefs();
  String url = '$mainURL${getScheduleInWeekURL}from=$from&to=$to';

  final response = await http.get(
    Uri.parse(url),
    headers: header,
  );
  final responseJson = jsonDecode(response.body);
  List<ScheduleToday> contracts = [];
  if (response.statusCode == 200) {
    print("aha");
    if (responseJson is List) {
      contracts = responseJson
          .map((json) => ScheduleToday.fromJson(json as Map<String, dynamic>))
          .toList();
    } else if (responseJson is Map<String, dynamic>) {
      ScheduleToday contract = ScheduleToday.fromJson(responseJson);

      contracts = [contract];
    }
    return contracts;
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
    print('Success to AddToCart');
  } else if (response.body.isEmpty) {
    throw Exception('Empty response body');
  }
  else {
    throw Exception('Đã có lỗi: ${response.statusCode}');
  }
}