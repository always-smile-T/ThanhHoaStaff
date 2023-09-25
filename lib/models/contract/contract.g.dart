// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contract _$ContractFromJson(Map<String, dynamic> json) => Contract(
      id: json['id'] as String?,
      title: json['title'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      reason: json['reason'] as String?,
      createdDate: json['createdDate'] as String?,
      confirmedDate: json['confirmedDate'] as String?,
      signedDate: json['signedDate'] as String?,
      startedDate: json['startedDate'] as String?,
      endedDate: json['endedDate'] as String?,
      expectedEndedDate: json['expectedEndedDate'] as String?,
      approvedDate: json['approvedDate'] as String?,
      rejectedDate: json['rejectedDate'] as String?,
      total: (json['total'] as num?)?.toDouble(),
      isFeedback: json['isFeedback'] as bool?,
      isSigned: json['isSigned'] as bool?,
      status: json['status'] as String?,
      isPaid: json['isPaid'] as bool?,
      imgList: (json['imgList'] as List<dynamic>?)
          ?.map((e) => ImgList.fromJson(e as Map<String, dynamic>))
          .toList(),
      showStaffModel: json['showStaffModel'] == null
          ? null
          : ShowStaffModel.fromJson(
              json['showStaffModel'] as Map<String, dynamic>),
      showCustomerModel: json['showCustomerModel'] == null
          ? null
          : ShowCustomerModel.fromJson(
              json['showCustomerModel'] as Map<String, dynamic>),
      showStoreModel: json['showStoreModel'] == null
          ? null
          : ShowStoreModel.fromJson(
              json['showStoreModel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ContractToJson(Contract instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'paymentMethod': instance.paymentMethod,
      'reason': instance.reason,
      'createdDate': instance.createdDate,
      'confirmedDate': instance.confirmedDate,
      'signedDate': instance.signedDate,
      'startedDate': instance.startedDate,
      'endedDate': instance.endedDate,
      'expectedEndedDate': instance.expectedEndedDate,
      'approvedDate': instance.approvedDate,
      'rejectedDate': instance.rejectedDate,
      'total': instance.total,
      'isFeedback': instance.isFeedback,
      'isSigned': instance.isSigned,
      'status': instance.status,
      'isPaid': instance.isPaid,
      'imgList': instance.imgList,
      'showStaffModel': instance.showStaffModel,
      'showCustomerModel': instance.showCustomerModel,
      'showStoreModel': instance.showStoreModel,
    };

ImgList _$ImgListFromJson(Map<String, dynamic> json) => ImgList(
      id: json['id'] as String?,
      imgUrl: json['imgUrl'] as String?,
    );

Map<String, dynamic> _$ImgListToJson(ImgList instance) => <String, dynamic>{
      'id': instance.id,
      'imgUrl': instance.imgUrl,
    };

ShowStaffModel _$ShowStaffModelFromJson(Map<String, dynamic> json) =>
    ShowStaffModel(
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      id: json['id'] as int?,
    );

Map<String, dynamic> _$ShowStaffModelToJson(ShowStaffModel instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'id': instance.id,
    };

ShowCustomerModel _$ShowCustomerModelFromJson(Map<String, dynamic> json) =>
    ShowCustomerModel(
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      id: json['id'] as int?,
    );

Map<String, dynamic> _$ShowCustomerModelToJson(ShowCustomerModel instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'id': instance.id,
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

ShowPaymentTypeModel _$ShowPaymentTypeModelFromJson(
        Map<String, dynamic> json) =>
    ShowPaymentTypeModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      value: json['value'] as int?,
    );

Map<String, dynamic> _$ShowPaymentTypeModelToJson(
        ShowPaymentTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'value': instance.value,
    };
