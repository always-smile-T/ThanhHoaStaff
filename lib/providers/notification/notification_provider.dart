import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../../models/notification/notification.dart';
import '../../utils/connection/utilsConnection.dart';
import '../../utils/helper/shared_prefs.dart';

Future<List<Noty>>   fetchNotification() async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  String url = mainURL + notificationURL;
  final response = await http.get(
    Uri.parse(url),
    headers: header,
  );
  final decoded = utf8.decode(response.bodyBytes);
  if (response.statusCode == 200) {
    List<Noty> notifications = ((jsonDecode(decoded)) as List)
        .map((json) => Noty.fromJson(json as Map<String, dynamic>))
        .toList();
    return notifications;
  } else {
    throw Exception('Failed to fetch contract details');
  }
}
Future readOneNoty(id) async {
  String url = mainURL + checkReadOneURL + '$id';
  final response = await http.put(
    Uri.parse(url),
    headers: headerLogin,
  );

  if (response.statusCode == 200) {
    print('ok');
  } else {
    throw Exception('Failed to fetch contract details');
  }
}

Future readAllNoty() async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  String url = mainURL + checkReadAllURL;
  final response = await http.put(
    Uri.parse(url),
    headers: header,
  );

  if (response.statusCode == 200) {
  } else {
    throw Exception('Failed to fetch contract details');
  }
}