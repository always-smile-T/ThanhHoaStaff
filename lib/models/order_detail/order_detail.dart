
import 'package:json_annotation/json_annotation.dart';
part 'order_detail.g.dart';

@JsonSerializable()
class OrderDetailbyID {
  String? id;
  int? quantity;
  double? price;
  bool? isFeedback;
  ShowOrderModel? showOrderModel;
  ShowPlantModel? showPlantModel;
  ShowStaffModel? showStaffModel;
  ShowCustomerModel? showCustomerModel;
  ShowDistancePriceModel? showDistancePriceModel;
  ShowStoreModel? showStoreModel;

  OrderDetailbyID(
      {this.id,
        this.quantity,
        this.price,
        this.isFeedback,
        this.showOrderModel,
        this.showPlantModel,
        this.showStaffModel,
        this.showCustomerModel,
        this.showDistancePriceModel,
        this.showStoreModel});
  factory OrderDetailbyID.fromJson(Map<String, dynamic> json) => _$OrderDetailbyIDFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailbyIDToJson(this);
}

@JsonSerializable()
class ShowOrderModel {
  String? id;
  String? fullName;
  String? email;
  String? phone;
  String? address;
  String? paymentMethod;
  String? progressStatus;
  String? reason;
  String? createdDate;
  String? packageDate;
  String? deliveryDate;
  String? receivedDate;
  String? approveDate;
  String? rejectDate;
  String? latLong;
  double? distance;
  double? totalShipCost;
  double? total;
  bool? isPaid;
  bool? isRefund;
  String? receiptIMG;
  ShowStaffModel? showStaffModel;
  ShowCustomerModel? showCustomerModel;
  ShowDistancePriceModel? showDistancePriceModel;
  ShowStoreModel? showStoreModel;
  ShowPlantModel? showPlantModel;

  ShowOrderModel(
      {this.id,
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
        this.isPaid,
        this.isRefund,
        this.receiptIMG,
        this.showStaffModel,
        this.showCustomerModel,
        this.showDistancePriceModel,
        this.showStoreModel,
        this.showPlantModel});
  factory ShowOrderModel.fromJson(Map<String, dynamic> json) => _$ShowOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShowOrderModelToJson(this);
}

@JsonSerializable()
class ShowPlantModel {
  String? id;
  int? quantity;
  String? plantName;
  String? plantPriceID;
  double? plantPrice;
  String? image;
  double? shipPrice;

  ShowPlantModel(
      {this.id,
        this.quantity,
        this.plantName,
        this.plantPriceID,
        this.plantPrice,
        this.image,
        this.shipPrice});
  factory ShowPlantModel.fromJson(Map<String, dynamic> json) => _$ShowPlantModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShowPlantModelToJson(this);
}

@JsonSerializable()
class ShowStaffModel {
  String? fullName;
  String? email;
  String? phone;
  String? address;
  int? id;
  String? avatar;
  bool? gender;
  String? status;

  ShowStaffModel(
      {this.fullName,
        this.email,
        this.phone,
        this.address,
        this.id,
        this.avatar,
        this.gender,
        this.status});
  factory ShowStaffModel.fromJson(Map<String, dynamic> json) => _$ShowStaffModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShowStaffModelToJson(this);
}

@JsonSerializable()
class ShowCustomerModel {
  String? fullName;
  String? email;
  String? phone;
  String? address;
  String? avatar;
  int? id;

  ShowCustomerModel(
      {this.fullName,
        this.email,
        this.phone,
        this.address,
        this.avatar,
        this.id});
  factory ShowCustomerModel.fromJson(Map<String, dynamic> json) => _$ShowCustomerModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShowCustomerModelToJson(this);
}

@JsonSerializable()
class ShowDistancePriceModel {
  String? id;
  String? applyDate;
  double? pricePerKm;

  ShowDistancePriceModel({this.id, this.applyDate, this.pricePerKm});
  factory ShowDistancePriceModel.fromJson(Map<String, dynamic> json) => _$ShowDistancePriceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShowDistancePriceModelToJson(this);
}

@JsonSerializable()
class ShowStoreModel {
  String? id;
  String? storeName;
  String? address;
  String? phone;

  ShowStoreModel({this.id, this.storeName, this.address, this.phone});
  factory ShowStoreModel.fromJson(Map<String, dynamic> json) => _$ShowStoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShowStoreModelToJson(this);
}