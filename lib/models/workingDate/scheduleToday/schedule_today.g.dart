// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_today.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkingInSchedule _$WorkingInScheduleFromJson(Map<String, dynamic> json) =>
    WorkingInSchedule(
      id: json['id'] as String?,
      workingDate: json['workingDate'] as String?,
      startWorking: json['startWorking'] as String?,
      endWorking: json['endWorking'] as String?,
      startWorkingIMG: json['startWorkingIMG'] as String?,
      endWorkingIMG: json['endWorkingIMG'] as String?,
      isReported: json['isReported'] as bool?,
      status: json['status'] as String?,
      contractID: json['contractID'] as String?,
      title: json['title'] as String?,
      fullName: json['fullName'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      contractDetailID: json['contractDetailID'] as String?,
      timeWorking: json['timeWorking'] as String?,
      note: json['note'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      expectedEndDate: json['expectedEndDate'] as String?,
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      plantStatus: json['plantStatus'] as String?,
      plantName: json['plantName'] as String?,
      serviceID: json['serviceID'] as String?,
      serviceName: json['serviceName'] as String?,
      serviceTypeID: json['serviceTypeID'] as String?,
      typeName: json['typeName'] as String?,
      typePercentage: json['typePercentage'] as int?,
      typeSize: json['typeSize'] as String?,
      typeApplyDate: json['typeApplyDate'] as String?,
      servicePackID: json['servicePackID'] as String?,
      packRange: json['packRange'] as String?,
      packPercentage: json['packPercentage'] as int?,
      packApplyDate: json['packApplyDate'] as String?,
      showStaffModel: json['showStaffModel'] == null
          ? null
          : ShowStaffModel.fromJson(
              json['showStaffModel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkingInScheduleToJson(WorkingInSchedule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workingDate': instance.workingDate,
      'startWorking': instance.startWorking,
      'endWorking': instance.endWorking,
      'startWorkingIMG': instance.startWorkingIMG,
      'endWorkingIMG': instance.endWorkingIMG,
      'isReported': instance.isReported,
      'status': instance.status,
      'contractID': instance.contractID,
      'title': instance.title,
      'fullName': instance.fullName,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'contractDetailID': instance.contractDetailID,
      'timeWorking': instance.timeWorking,
      'note': instance.note,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'expectedEndDate': instance.expectedEndDate,
      'totalPrice': instance.totalPrice,
      'plantStatus': instance.plantStatus,
      'plantName': instance.plantName,
      'serviceID': instance.serviceID,
      'serviceName': instance.serviceName,
      'serviceTypeID': instance.serviceTypeID,
      'typeName': instance.typeName,
      'typePercentage': instance.typePercentage,
      'typeSize': instance.typeSize,
      'typeApplyDate': instance.typeApplyDate,
      'servicePackID': instance.servicePackID,
      'packRange': instance.packRange,
      'packPercentage': instance.packPercentage,
      'packApplyDate': instance.packApplyDate,
      'showStaffModel': instance.showStaffModel,
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
      totalPage: json['totalPage'] as int?,
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
      'totalPage': instance.totalPage,
    };
