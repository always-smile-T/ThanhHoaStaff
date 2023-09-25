import 'dart:collection';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../constants/constants.dart';
import '../../models/contract/contract.dart';
import '../../models/contract/contractDetail/contract_detail.dart';
import '../../models/manaContract/manaServicePack/mana_service_pack.dart';
import '../../models/manaContract/manaServiceType/mana_service_type.dart';
import '../../models/order_detail/order_detail.dart';
import '../../utils/connection/utilsConnection.dart';
import '../../utils/helper/shared_prefs.dart';


Future<List<Contract>> fetchContract( pageNo, pageSize, sortBy, status) async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  var token = getTokenAuthenFromSharedPrefs();
  String url = '$mainURL$getContractURL&pageNo=$pageNo&pageSize=$pageSize&sortBy=$sortBy&sortAsc=$status';
  print('token: ');
  print(token);
  final response = await http.get(
    Uri.parse(url),
    headers: header,
  );
  final responseJson = jsonDecode(response.body);

  List<Contract> contracts = [];
  if (response.statusCode == 200) {
    if (responseJson is List) {
      contracts = responseJson
          .map((json) => Contract.fromJson(json as Map<String, dynamic>))
          .toList();
    } else if (responseJson is Map<String, dynamic>) {
      Contract contract = Contract.fromJson(responseJson);

      contracts = [contract];
    }
    return contracts;
  } else {
    throw Exception('Failed to fetch contract details');
  }
}
Future<List<ContractDetail>> fetchAllContractDetailOLD() async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  String url = mainURL + getAllContractDetailURL;
  final response = await http.get(
      Uri.parse(url),
      headers: header
  );

  final decoded = utf8.decode(response.bodyBytes);
  
  if (response.statusCode == 200) {
    List<ContractDetail> contractDetails = (jsonDecode(decoded) as List)
        .map((json) => ContractDetail.fromJson(json as Map<String, dynamic>))
        .toList();
    return contractDetails;
  } else {
    throw Exception('Failed to fetch contract details');
  }
}



Future<List<ContractDetail>> fetchContractDetailByID(id, pageNo, pageSize) async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  String url = 'https://thanhhoagarden.herokuapp.com/contract/contractDetail/$id?pageNo=$pageNo&pageSize=$pageSize&sortBy=ID&sortAsc=true';
  final response = await http.get(
    Uri.parse(url),
    headers: header,
  );
  final decoded = utf8.decode(response.bodyBytes);
  print(decoded);
  if (response.statusCode == 200) {
    List<ContractDetail> contractDetails = ((jsonDecode(decoded)) as List)
        .map((json) => ContractDetail.fromJson(json as Map<String, dynamic>))
        .toList();
    print(contractDetails);
    return contractDetails;
  } else {
    throw Exception('Failed to fetch contract details');
  }
}

Future<List<ManaServiceType>> fetchServiceTypeByID(serviceId) async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  String url = 'https://thanhhoagarden.herokuapp.com/service/serviceType/$serviceId';
  final response = await http.get(
    Uri.parse(url),
    headers: header,
  );
  final decoded = utf8.decode(response.bodyBytes);
  print(decoded);
  if (response.statusCode == 200) {
    List<ManaServiceType> services = ((jsonDecode(decoded)) as List)
        .map((json) => ManaServiceType.fromJson(json as Map<String, dynamic>))
        .toList();
    print(services);
    return services;
  } else {
    throw Exception('Failed to fetch contract details');
  }
}
Future<List<ManaServicePack>> fetchServicePack() async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  String url = 'https://thanhhoagarden.herokuapp.com/servicePack';
  final response = await http.get(
    Uri.parse(url),
    headers: header,
  );
  final decoded = utf8.decode(response.bodyBytes);
  print(decoded);
  if (response.statusCode == 200) {
    List<ManaServicePack> packs = ((jsonDecode(decoded)) as List)
        .map((json) => ManaServicePack.fromJson(json as Map<String, dynamic>))
        .toList();
    return packs;
  } else {
    throw Exception('Failed to fetch contract details');
  }
}


Future<Contract> fetchAContract( contractId) async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  String url = 'https://thanhhoagarden.herokuapp.com/contract/getByID?contractID=$contractId';
  final response = await http.get(
    Uri.parse(url),
    headers: header,
  );
  print("response.statusCode: " + response.statusCode.toString());
  final responseJson = jsonDecode(response.body);
  if (response.statusCode == 200) {
    Contract contract = Contract.fromJson(responseJson);
    return contract;
  } else {
    throw Exception('Failed to fetch contract details');
  }
}

/*Future<List<OrderDetailbyID>> fetchAOrder( OrderrId) async {
  String url = 'https://thanhhoagarden.herokuapp.com/order/getByID?orderID=$OrderrId';
  var header = getheader(getTokenAuthenFromSharedPrefs());
  final response = await http.get(
    Uri.parse(url),
    headers: header,
  );
  final decoded = utf8.decode(response.bodyBytes);
  //print(decoded);
  if (response.statusCode == 200) {

    List<OrderDetailbyID> orderDetails = ((jsonDecode(decoded)) as List)
        .map((json) => OrderDetailbyID.fromJson(json as Map<String, dynamic>))
        .toList();
    return orderDetails;
  } else {
    throw Exception('Failed to fetch contract details');
  }

}*/

Future<List<OrderDetailbyID>?> fetchAOrder(OrderrId) async {
  String url = 'https://thanhhoagarden.herokuapp.com/order/orderDetail/$OrderrId';
  var header = getheader(getTokenAuthenFromSharedPrefs());

    final response = await http.get(
      Uri.parse(url),
      headers: header,
    );
    final decoded = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      List<OrderDetailbyID> orderDetails = ((jsonDecode(decoded)) as List)
          .map((json) => OrderDetailbyID.fromJson(json as Map<String, dynamic>))
          .toList();
      return orderDetails;
    }
  throw Exception('API returned status code: ${response.statusCode}');
  }
Future changeContractStatus(contractID, status, reason, staffID) async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  String url = '';
  (reason == null) ?  url = '$mainURL/contract/changeContractStatus?contractID=$contractID&staffID=$staffID&status=$status' :
  '$mainURL/contract/changeContractStatus?contractID=$contractID&staffID=$staffID&reason=$reason&status=$status';
  final response = await http.put(
    Uri.parse(url),
    headers: header,
  );
  print("url: " + url);

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
    print("response.statusCode: "+ response.statusCode.toString());
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
Future addContractIMG(contractID, IMG) async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  String url = 'https://thanhhoagarden.herokuapp.com/contract/addContractIMG?contractID=$contractID&listURL=$IMG';
  final response = await http.post(
    Uri.parse(url),
    headers: header,
  );
  print("url: "+ url);
  print("response: "+ response.headers.toString());
  if (response.statusCode == 200) {
    Fluttertoast.showToast(
        msg: "Đã Ký Hợp Đồng",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: buttonColor,
        textColor: Colors.white,
        fontSize: 16.0);
  } else {
    print("response.statusCode: "+ response.statusCode.toString());
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

Future<void> ChangeContractDetail (jsonData) async {
  String jsonDataString = json.encode(jsonData);
  var header = getheader(getTokenAuthenFromSharedPrefs());
  String url = 'https://thanhhoagarden.herokuapp.com/contract';
  final response = await http.put(
    Uri.parse(url),
    headers: header,
    body: jsonDataString
  );
  print("jsonDataString: " + jsonDataString.toString());
  print("request: " + response.request.toString());
  if (response.statusCode == 200) {
    Fluttertoast.showToast(
        msg: "Đã sửa dịch vụ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: buttonColor,
        textColor: Colors.white,
        fontSize: 16.0);
  } else {
    print("response.statusCode: "+ response.statusCode.toString());
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