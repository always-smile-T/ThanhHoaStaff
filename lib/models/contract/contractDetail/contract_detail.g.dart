// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractDetail _$ContractDetailFromJson(Map<String, dynamic> json) =>
    ContractDetail(
      id: json['id'] as String?,
      timeWorking: json['timeWorking'] as String?,
      note: json['note'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      expectedEndDate: json['expectedEndDate'] as String?,
      plantStatus: json['plantStatus'] as String?,
      plantName: json['plantName'] as String?,
      plantIMG: json['plantIMG'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      showContractModel: json['showContractModel'] == null
          ? null
          : ShowContractModel.fromJson(
              json['showContractModel'] as Map<String, dynamic>),
      showServiceTypeModel: json['showServiceTypeModel'] == null
          ? null
          : ShowServiceTypeModel.fromJson(
              json['showServiceTypeModel'] as Map<String, dynamic>),
      showServiceModel: json['showServiceModel'] == null
          ? null
          : ShowServiceModel.fromJson(
              json['showServiceModel'] as Map<String, dynamic>),
      showServicePackModel: json['showServicePackModel'] == null
          ? null
          : ShowServicePackModel.fromJson(
              json['showServicePackModel'] as Map<String, dynamic>),
      workingDateList: (json['workingDateList'] as List<dynamic>?)
          ?.map((e) => WorkingDateList.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..plantStatusIMGModelList = (json['plantStatusIMGModelList']
            as List<dynamic>?)
        ?.map(
            (e) => PlantStatusIMGModelList.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$ContractDetailToJson(ContractDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timeWorking': instance.timeWorking,
      'note': instance.note,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'expectedEndDate': instance.expectedEndDate,
      'plantStatus': instance.plantStatus,
      'plantName': instance.plantName,
      'plantIMG': instance.plantIMG,
      'price': instance.price,
      'totalPrice': instance.totalPrice,
      'showContractModel': instance.showContractModel,
      'showServiceTypeModel': instance.showServiceTypeModel,
      'showServiceModel': instance.showServiceModel,
      'showServicePackModel': instance.showServicePackModel,
      'workingDateList': instance.workingDateList,
      'plantStatusIMGModelList': instance.plantStatusIMGModelList,
    };

ShowContractModel _$ShowContractModelFromJson(Map<String, dynamic> json) =>
    ShowContractModel(
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

Map<String, dynamic> _$ShowContractModelToJson(ShowContractModel instance) =>
    <String, dynamic>{
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

ShowServiceTypeModel _$ShowServiceTypeModelFromJson(
        Map<String, dynamic> json) =>
    ShowServiceTypeModel(
      id: json['id'] as String?,
      typeName: json['typeName'] as String?,
      typePercentage: json['typePercentage'] as int?,
      typeSize: json['typeSize'] as String?,
      typeUnit: json['typeUnit'] as String?,
      typeApplyDate: json['typeApplyDate'] as String?,
    );

Map<String, dynamic> _$ShowServiceTypeModelToJson(
        ShowServiceTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'typeName': instance.typeName,
      'typePercentage': instance.typePercentage,
      'typeSize': instance.typeSize,
      'typeUnit': instance.typeUnit,
      'typeApplyDate': instance.typeApplyDate,
    };

ShowServiceModel _$ShowServiceModelFromJson(Map<String, dynamic> json) =>
    ShowServiceModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      priceID: json['priceID'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      atHome: json['atHome'] as bool?,
    );

Map<String, dynamic> _$ShowServiceModelToJson(ShowServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'priceID': instance.priceID,
      'price': instance.price,
      'atHome': instance.atHome,
    };

ShowServicePackModel _$ShowServicePackModelFromJson(
        Map<String, dynamic> json) =>
    ShowServicePackModel(
      id: json['id'] as String?,
      packRange: json['packRange'] as String?,
      packUnit: json['packUnit'] as String?,
      packPercentage: json['packPercentage'] as int?,
      packApplyDate: json['packApplyDate'] as String?,
    );

Map<String, dynamic> _$ShowServicePackModelToJson(
        ShowServicePackModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'packRange': instance.packRange,
      'packUnit': instance.packUnit,
      'packPercentage': instance.packPercentage,
      'packApplyDate': instance.packApplyDate,
    };

WorkingDateList _$WorkingDateListFromJson(Map<String, dynamic> json) =>
    WorkingDateList(
      id: json['id'] as String?,
      workingDate: json['workingDate'] as String?,
      startWorking: json['startWorking'] as String?,
      endWorking: json['endWorking'] as String?,
      startWorkingIMG: json['startWorkingIMG'] as String?,
      endWorkingIMG: json['endWorkingIMG'] as String?,
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
      plantIMG: json['plantIMG'] as String?,
      serviceID: json['serviceID'] as String?,
      serviceName: json['serviceName'] as String?,
      serviceTypeID: json['serviceTypeID'] as String?,
      typeName: json['typeName'] as String?,
      typePercentage: json['typePercentage'] as int?,
      typeSize: json['typeSize'] as String?,
      typeUnit: json['typeUnit'] as String?,
      typeApplyDate: json['typeApplyDate'] as String?,
      servicePackID: json['servicePackID'] as String?,
      packRange: json['packRange'] as String?,
      packUnit: json['packUnit'] as String?,
      packPercentage: json['packPercentage'] as int?,
      packApplyDate: json['packApplyDate'] as String?,
      showStaffModel: json['showStaffModel'] == null
          ? null
          : ShowStaffModel.fromJson(
              json['showStaffModel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkingDateListToJson(WorkingDateList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workingDate': instance.workingDate,
      'startWorking': instance.startWorking,
      'endWorking': instance.endWorking,
      'startWorkingIMG': instance.startWorkingIMG,
      'endWorkingIMG': instance.endWorkingIMG,
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
      'plantIMG': instance.plantIMG,
      'serviceID': instance.serviceID,
      'serviceName': instance.serviceName,
      'serviceTypeID': instance.serviceTypeID,
      'typeName': instance.typeName,
      'typePercentage': instance.typePercentage,
      'typeSize': instance.typeSize,
      'typeUnit': instance.typeUnit,
      'typeApplyDate': instance.typeApplyDate,
      'servicePackID': instance.servicePackID,
      'packRange': instance.packRange,
      'packUnit': instance.packUnit,
      'packPercentage': instance.packPercentage,
      'packApplyDate': instance.packApplyDate,
      'showStaffModel': instance.showStaffModel,
    };

PlantStatusIMGModelList _$PlantStatusIMGModelListFromJson(
        Map<String, dynamic> json) =>
    PlantStatusIMGModelList(
      id: json['id'] as String?,
      imgUrl: json['imgUrl'] as String?,
    );

Map<String, dynamic> _$PlantStatusIMGModelListToJson(
        PlantStatusIMGModelList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imgUrl': instance.imgUrl,
    };
