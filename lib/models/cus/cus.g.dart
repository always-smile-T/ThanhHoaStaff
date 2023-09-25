// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cus _$CusFromJson(Map<String, dynamic> json) => Cus(
      userID: json['userID'] as int?,
      userName: json['userName'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      address: json['address'] as String?,
      gender: json['gender'] as bool?,
      status: json['status'] as String?,
      createdDate: json['createdDate'] as String?,
      roleID: json['roleID'] as String?,
      roleName: json['roleName'] as String?,
    );

Map<String, dynamic> _$CusToJson(Cus instance) => <String, dynamic>{
      'userID': instance.userID,
      'userName': instance.userName,
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'address': instance.address,
      'gender': instance.gender,
      'status': instance.status,
      'createdDate': instance.createdDate,
      'roleID': instance.roleID,
      'roleName': instance.roleName,
    };
