// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailbyID _$OrderDetailbyIDFromJson(Map<String, dynamic> json) =>
    OrderDetailbyID(
      id: json['id'] as String?,
      quantity: json['quantity'] as int?,
      price: (json['price'] as num?)?.toDouble(),
      isFeedback: json['isFeedback'] as bool?,
      showOrderModel: json['showOrderModel'] == null
          ? null
          : ShowOrderModel.fromJson(
              json['showOrderModel'] as Map<String, dynamic>),
      showPlantModel: json['showPlantModel'] == null
          ? null
          : ShowPlantModel.fromJson(
              json['showPlantModel'] as Map<String, dynamic>),
      showStaffModel: json['showStaffModel'] == null
          ? null
          : ShowStaffModel.fromJson(
              json['showStaffModel'] as Map<String, dynamic>),
      showCustomerModel: json['showCustomerModel'] == null
          ? null
          : ShowCustomerModel.fromJson(
              json['showCustomerModel'] as Map<String, dynamic>),
      showDistancePriceModel: json['showDistancePriceModel'] == null
          ? null
          : ShowDistancePriceModel.fromJson(
              json['showDistancePriceModel'] as Map<String, dynamic>),
      showStoreModel: json['showStoreModel'] == null
          ? null
          : ShowStoreModel.fromJson(
              json['showStoreModel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderDetailbyIDToJson(OrderDetailbyID instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'price': instance.price,
      'isFeedback': instance.isFeedback,
      'showOrderModel': instance.showOrderModel,
      'showPlantModel': instance.showPlantModel,
      'showStaffModel': instance.showStaffModel,
      'showCustomerModel': instance.showCustomerModel,
      'showDistancePriceModel': instance.showDistancePriceModel,
      'showStoreModel': instance.showStoreModel,
    };

ShowOrderModel _$ShowOrderModelFromJson(Map<String, dynamic> json) =>
    ShowOrderModel(
      id: json['id'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      progressStatus: json['progressStatus'] as String?,
      reason: json['reason'] as String?,
      createdDate: json['createdDate'] as String?,
      packageDate: json['packageDate'] as String?,
      deliveryDate: json['deliveryDate'] as String?,
      receivedDate: json['receivedDate'] as String?,
      approveDate: json['approveDate'] as String?,
      rejectDate: json['rejectDate'] as String?,
      latLong: json['latLong'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
      totalShipCost: (json['totalShipCost'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
      isPaid: json['isPaid'] as bool?,
      isRefund: json['isRefund'] as bool?,
      receiptIMG: json['receiptIMG'] as String?,
      showStaffModel: json['showStaffModel'] == null
          ? null
          : ShowStaffModel.fromJson(
              json['showStaffModel'] as Map<String, dynamic>),
      showCustomerModel: json['showCustomerModel'] == null
          ? null
          : ShowCustomerModel.fromJson(
              json['showCustomerModel'] as Map<String, dynamic>),
      showDistancePriceModel: json['showDistancePriceModel'] == null
          ? null
          : ShowDistancePriceModel.fromJson(
              json['showDistancePriceModel'] as Map<String, dynamic>),
      showStoreModel: json['showStoreModel'] == null
          ? null
          : ShowStoreModel.fromJson(
              json['showStoreModel'] as Map<String, dynamic>),
      showPlantModel: json['showPlantModel'] == null
          ? null
          : ShowPlantModel.fromJson(
              json['showPlantModel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShowOrderModelToJson(ShowOrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'paymentMethod': instance.paymentMethod,
      'progressStatus': instance.progressStatus,
      'reason': instance.reason,
      'createdDate': instance.createdDate,
      'packageDate': instance.packageDate,
      'deliveryDate': instance.deliveryDate,
      'receivedDate': instance.receivedDate,
      'approveDate': instance.approveDate,
      'rejectDate': instance.rejectDate,
      'latLong': instance.latLong,
      'distance': instance.distance,
      'totalShipCost': instance.totalShipCost,
      'total': instance.total,
      'isPaid': instance.isPaid,
      'isRefund': instance.isRefund,
      'receiptIMG': instance.receiptIMG,
      'showStaffModel': instance.showStaffModel,
      'showCustomerModel': instance.showCustomerModel,
      'showDistancePriceModel': instance.showDistancePriceModel,
      'showStoreModel': instance.showStoreModel,
      'showPlantModel': instance.showPlantModel,
    };

ShowPlantModel _$ShowPlantModelFromJson(Map<String, dynamic> json) =>
    ShowPlantModel(
      id: json['id'] as String?,
      quantity: json['quantity'] as int?,
      plantName: json['plantName'] as String?,
      plantPriceID: json['plantPriceID'] as String?,
      plantPrice: (json['plantPrice'] as num?)?.toDouble(),
      image: json['image'] as String?,
      shipPrice: (json['shipPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ShowPlantModelToJson(ShowPlantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'plantName': instance.plantName,
      'plantPriceID': instance.plantPriceID,
      'plantPrice': instance.plantPrice,
      'image': instance.image,
      'shipPrice': instance.shipPrice,
    };

ShowStaffModel _$ShowStaffModelFromJson(Map<String, dynamic> json) =>
    ShowStaffModel(
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      id: json['id'] as int?,
      avatar: json['avatar'] as String?,
      gender: json['gender'] as bool?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$ShowStaffModelToJson(ShowStaffModel instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'id': instance.id,
      'avatar': instance.avatar,
      'gender': instance.gender,
      'status': instance.status,
    };

ShowCustomerModel _$ShowCustomerModelFromJson(Map<String, dynamic> json) =>
    ShowCustomerModel(
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      avatar: json['avatar'] as String?,
      id: json['id'] as int?,
    );

Map<String, dynamic> _$ShowCustomerModelToJson(ShowCustomerModel instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'avatar': instance.avatar,
      'id': instance.id,
    };

ShowDistancePriceModel _$ShowDistancePriceModelFromJson(
        Map<String, dynamic> json) =>
    ShowDistancePriceModel(
      id: json['id'] as String?,
      applyDate: json['applyDate'] as String?,
      pricePerKm: (json['pricePerKm'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ShowDistancePriceModelToJson(
        ShowDistancePriceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'applyDate': instance.applyDate,
      'pricePerKm': instance.pricePerKm,
    };

ShowStoreModel _$ShowStoreModelFromJson(Map<String, dynamic> json) =>
    ShowStoreModel(
      id: json['id'] as String?,
      storeName: json['storeName'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$ShowStoreModelToJson(ShowStoreModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storeName': instance.storeName,
      'address': instance.address,
      'phone': instance.phone,
    };
