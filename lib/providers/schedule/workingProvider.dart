import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../blocs/workingDate/workingDate_event.dart';
import '../../models/workingDate/schedule/working_date.dart';
import '../../utils/connection/utilsConnection.dart';
import '../../utils/helper/shared_prefs.dart';
import 'package:http/http.dart' as http;

class WorkingDateProvider extends ChangeNotifier {
  WorkingDate? _workingDate;
  WorkingDate? get workingDate => _workingDate;

  List<WorkingDate>? _list;
  List<WorkingDate>? get listWorkingDate => _list;

  Future<bool> getWorkingDate(WorkingDateEvent event) async {
    bool result = false;
    List<WorkingDate> list = [];
    Map<String, dynamic> param = ({});
    param['from'] = event.from;
    param['to'] = '${event.to}';
    if (event.contractDetailID != null) {
      param['contractDetailID'] = event.contractDetailID;
    }
    String queryString = Uri(queryParameters: param).query;
    var header = getheader(getTokenAuthenFromSharedPrefs());
    try {
      final res = await http.get(
          Uri.parse(mainURL + getWorkingURL + queryString),
          headers: header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          for (var data in jsondata) {
            _workingDate = WorkingDate.fromJson2(data);
            list.add(_workingDate!);
          }
        }
        _list = list;
        notifyListeners();
        result = true;
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
