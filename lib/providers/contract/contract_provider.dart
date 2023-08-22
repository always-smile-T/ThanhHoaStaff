import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../../models/authentication/user.dart';
import '../../models/cart/cart.dart';
import '../../models/contract/contract.dart';
import '../../models/contract/contractDetail/contract_detail.dart';
import '../../models/order/distance.dart';
import '../../models/order/order.dart';
import '../../models/store/store.dart';
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
    return contractDetails;
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
  final responseJson = jsonDecode(response.body);
  if (response.statusCode == 200) {
    Contract contract = Contract.fromJson(responseJson);
    return contract;
  } else {
    throw Exception('Failed to fetch contract details');
  }
}

Future<OrderObject> fetchAOrder( OrderrId) async {
  var header = getheader(getTokenAuthenFromSharedPrefs());
  String url = 'https://thanhhoagarden.herokuapp.com/order/getByID?orderID=$OrderrId';
  final response = await http.get(
    Uri.parse(url),
    headers: header,
  );
  final responseJson = jsonDecode(response.body);
  if (response.statusCode == 200) {
    OrderCart plant = OrderCart();
    User showStaffModel = User();
    User showCustomerModel = User();
    Distance showDistancePriceModel = Distance();
    Store showStoreModel = Store();
    plant = OrderCart.fromJson(responseJson['showPlantModel']);
    showStaffModel = User.fetchInfo(responseJson['showStaffModel']);
    showCustomerModel = User.fetchInfo(responseJson['showCustomerModel']);
    showDistancePriceModel =
        Distance.fromJson(responseJson['showDistancePriceModel']);
    showStoreModel = Store.fromJson(responseJson['showStoreModel']);
    OrderObject contract = OrderObject.fromJson(
        responseJson['showOrderModel'],
        showStaffModel,
        showCustomerModel,
        showDistancePriceModel,
        showStoreModel,
        plant);
    return contract;
  } else {
    throw Exception('Failed to fetch contract details');
  }
}