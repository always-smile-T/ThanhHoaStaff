import '../../models/authentication/user.dart';
import '../../models/cart/cart.dart';
import '../../models/feedback/feedback.dart';
import '../../models/order/distance.dart';
import '../../models/store/store.dart';

class OrderObject {
  late final id;
  late final fullName;
  late final email;
  late final phone;
  late final address;
  late final paymentMethod;
  late final progressStatus;
  late final reason;
  late final createdDate;
  late final packageDate;
  late final deliveryDate;
  late final receivedDate;
  late final approveDate;
  late final rejectDate;
  late final latLong;
  late final distance;
  late final totalShipCost;
  late final total;
  late final status;
  late final numOfPlant;
  late User? showStaffModel;
  late User? showCustomerModel;
  late Distance? showDistancePriceModel;
  late Store? showStoreModel;
  late OrderCart? showPlantModel;
  late final totalPage;
  late final isPaid;
  late final receiptIMG;
  late final transactionNo;
  late final customerID;

  OrderObject({
    this.id,
    this.fullName,
    this.email,
    this.phone,
    this.address,
    this.paymentMethod,
    this.progressStatus,
    this.reason,
    this.createdDate,
    this.packageDate,
    this.deliveryDate,
    this.receivedDate,
    this.approveDate,
    this.rejectDate,
    this.latLong,
    this.distance,
    this.totalShipCost,
    this.total,
    this.status,
    this.showStaffModel,
    this.showCustomerModel,
    this.showDistancePriceModel,
    this.showStoreModel,
    this.showPlantModel,
    this.totalPage,
    this.numOfPlant,
    this.isPaid,
    this.receiptIMG,
    this.transactionNo,
    this.customerID
  });

  OrderObject.fromJson(
      Map<String, dynamic> json,
      User? StaffModel,
      User? CustomerModel,
      Distance? DistancePriceModel,
      Store? StoreModel,
      OrderCart? PlantModel,
      ) {
    id = json["id"];
    fullName = json["fullName"];
    email = json["email"];
    phone = json["phone"];
    address = json["address"];
    paymentMethod = json["paymentMethod"];
    progressStatus = json["progressStatus"];
    reason = json["reason"];
    createdDate = json["createdDate"];
    packageDate = json["packageDate"];
    deliveryDate = json["deliveryDate"];
    receivedDate = json["receivedDate"];
    approveDate = json["approveDate"];
    rejectDate = json["rejectDate"];
    latLong = json["latLong"];
    distance = json["distance"];
    total = json["total"];
    status = json["status"];
    totalPage = json["totalPage"];
    numOfPlant = json["numOfPlant"];
    totalShipCost = json["totalShipCost"];
    showStaffModel = StaffModel;
    showCustomerModel = CustomerModel;
    showDistancePriceModel = DistancePriceModel;
    showStoreModel = StoreModel;
    showPlantModel = PlantModel;
    isPaid = json["isPaid"];
    receiptIMG = json["receiptIMG"];
    transactionNo = json["transactionNo"];
    customerID = json["customerID"];
  }

  Map<String, dynamic> createOrder(List<Map<String, dynamic>> plant,
      String StoreID, String DistancePriceID, staffID,transactionNo, customerID) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['paymentMethod'] = paymentMethod;
    data['distance'] = distance;
    data['storeID'] = StoreID;
    data['distancePriceID'] = DistancePriceID;
    data['detailList'] = plant;
    data['staffID'] = staffID;
    data['isPaid'] = true;
    data['transactionNo'] = transactionNo;
    data['customerID'] = customerID;
    return data;
  }
}

class OrderDetail {
  late final id;
  late final quantity;
  late final price;
  late final isFeedback;
  late User? showStaffModel;
  late User? showCustomerModel;
  late Distance? showDistancePriceModel;
  late Store? showStoreModel;
  late OrderCart? showPlantModel;
  late FeedbackModel? showFeedbackModel;
  late OrderObject? showOrderModel;
  late final totalPage;

  OrderDetail(
      {this.id,
        this.quantity,
        this.price,
        this.isFeedback,
        this.showPlantModel,
        this.showCustomerModel,
        this.showDistancePriceModel,
        this.showStoreModel,
        this.showStaffModel,
        this.showFeedbackModel,
        this.showOrderModel,
        this.totalPage});

  OrderDetail.fromJson(
      Map<String, dynamic> json,
      User? StaffModel,
      User? CustomerModel,
      Distance? DistancePriceModel,
      Store? StoreModel,
      OrderCart? PlantModel,
      FeedbackModel? FeedbackModel,
      OrderObject? OrderModel,
      ) {
    id = json["id"];
    quantity = json["quantity"];
    price = json["price"];
    isFeedback = json["isFeedback"];
    showPlantModel = PlantModel;
    showCustomerModel = CustomerModel;
    showDistancePriceModel = DistancePriceModel;
    showStoreModel = StoreModel;
    showStaffModel = StaffModel;
    showFeedbackModel = FeedbackModel;
    showOrderModel = OrderModel;
  }
}
