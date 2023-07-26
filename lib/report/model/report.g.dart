// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      id: json['id'] as String?,
      description: json['description'] as String?,
      reason: json['reason'] as String?,
      status: json['status'] as String?,
      createdDate: json['createdDate'] as String?,
      contractDetailID: json['contractDetailID'] as String?,
      serviceTypeID: json['serviceTypeID'] as String?,
      serviceTypeName: json['serviceTypeName'] as String?,
      serviceID: json['serviceID'] as String?,
      serviceName: json['serviceName'] as String?,
      customerID: json['customerID'] as int?,
      fullName: json['fullName'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      staffID: json['staffID'] as int?,
      staffName: json['staffName'] as String?,
      contractID: json['contractID'] as String?,
      timeWorking: json['timeWorking'] as String?,
      totalPage: json['totalPage'],
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'reason': instance.reason,
      'status': instance.status,
      'createdDate': instance.createdDate,
      'contractDetailID': instance.contractDetailID,
      'serviceTypeID': instance.serviceTypeID,
      'serviceTypeName': instance.serviceTypeName,
      'serviceID': instance.serviceID,
      'serviceName': instance.serviceName,
      'customerID': instance.customerID,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'email': instance.email,
      'staffID': instance.staffID,
      'staffName': instance.staffName,
      'contractID': instance.contractID,
      'timeWorking': instance.timeWorking,
      'totalPage': instance.totalPage,
    };
