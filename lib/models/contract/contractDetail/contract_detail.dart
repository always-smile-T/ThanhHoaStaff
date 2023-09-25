import 'package:json_annotation/json_annotation.dart';
import 'package:thanhhoa_garden_staff_app/models/contract/contract.dart';
part 'contract_detail.g.dart';

@JsonSerializable()
class ContractDetail {
  String? id;
  String? timeWorking;
  String? note;
  String? startDate;
  String? endDate;
  String? expectedEndDate;
  String? plantStatus;
  String? plantIMG;
  double? price;
  double? totalPrice;
  ShowContractModel? showContractModel;
  ShowServiceTypeModel? showServiceTypeModel;
  ShowServiceModel? showServiceModel;
  ShowServicePackModel? showServicePackModel;
  List<WorkingDateList>? workingDateList;
  List<PlantStatusIMGModelList>? plantStatusIMGModelList;
  //late final totalPage;

  ContractDetail(
      {this.id,
        this.timeWorking,
        this.note,
        this.startDate,
        this.endDate,
        this.expectedEndDate,
        this.plantStatus,
        this.plantIMG,
        this.price,
        this.totalPrice,
        this.showContractModel,
        this.showServiceTypeModel,
        this.showServiceModel,
        this.showServicePackModel,
        this.workingDateList,
      });

  factory ContractDetail.fromJson(Map<String, dynamic> json) => _$ContractDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ContractDetailToJson(this);
}


@JsonSerializable()
class ShowContractModel {
  String? id;
  String? title;
  String? fullName;
  String? email;
  String? phone;
  String? address;
  String? paymentMethod;
  String? reason;
  String? createdDate;
  String? confirmedDate;
  String? signedDate;
  String? startedDate;
  String? endedDate;
  String? expectedEndedDate;
  String? approvedDate;
  String? rejectedDate;
  double? total;
  bool? isFeedback;
  bool? isSigned;
  String? status;
  bool? isPaid;
  List<ImgList>? imgList;
  ShowStaffModel? showStaffModel;
  ShowCustomerModel? showCustomerModel;
  ShowStoreModel? showStoreModel;
  //late final totalPage;

  ShowContractModel(
      {this.id,
        this.title,
        this.fullName,
        this.email,
        this.phone,
        this.address,
        this.paymentMethod,
        this.reason,
        this.createdDate,
        this.confirmedDate,
        this.signedDate,
        this.startedDate,
        this.endedDate,
        this.expectedEndedDate,
        this.approvedDate,
        this.rejectedDate,
        this.total,
        this.isFeedback,
        this.isSigned,
        this.status,
        this.isPaid,
        this.imgList,
        this.showStaffModel,
        this.showCustomerModel,
        this.showStoreModel,
        //this.totalPage
      });

  factory ShowContractModel.fromJson(Map<String, dynamic> json) => _$ShowContractModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShowContractModelToJson(this);
}
@JsonSerializable()
class ImgList {
  String? id;
  String? imgUrl;

  ImgList({this.id, this.imgUrl});

  factory ImgList.fromJson(Map<String, dynamic> json) => _$ImgListFromJson(json);

  Map<String, dynamic> toJson() => _$ImgListToJson(this);
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
  //late final totalPage;

  ShowStaffModel(
      {this.fullName,
        this.email,
        this.phone,
        this.address,
        this.id,
        this.avatar,
        this.gender,
        this.status,
      //  this.totalPage
      });


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
class ShowStoreModel {
  String? id;
  String? storeName;
  String? address;
  String? phone;

  ShowStoreModel({this.id, this.storeName, this.address, this.phone});

  factory ShowStoreModel.fromJson(Map<String, dynamic> json) => _$ShowStoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShowStoreModelToJson(this);
}
@JsonSerializable()
class ShowServiceTypeModel {
  String? id;
  String? typeName;
  int? typePercentage;
  String? typeSize;
  String? typeUnit;
  String? typeApplyDate;

  ShowServiceTypeModel(
      {this.id,
        this.typeName,
        this.typePercentage,
        this.typeSize,
        this.typeUnit,
        this.typeApplyDate});

  factory ShowServiceTypeModel.fromJson(Map<String, dynamic> json) => _$ShowServiceTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShowServiceTypeModelToJson(this);
}
@JsonSerializable()
class ShowServiceModel {
  String? id;
  String? name;
  String? description;
  String? priceID;
  double? price;
  bool? atHome;

  ShowServiceModel(
      {this.id,
        this.name,
        this.description,
        this.priceID,
        this.price,
        this.atHome});

  factory ShowServiceModel.fromJson(Map<String, dynamic> json) => _$ShowServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShowServiceModelToJson(this);
}
@JsonSerializable()
class ShowServicePackModel {
  String? id;
  String? packRange;
  String? packUnit;
  int? packPercentage;
  String? packApplyDate;

  ShowServicePackModel(
      {this.id,
        this.packRange,
        this.packUnit,
        this.packPercentage,
        this.packApplyDate});

  factory ShowServicePackModel.fromJson(Map<String, dynamic> json) => _$ShowServicePackModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShowServicePackModelToJson(this);
}
@JsonSerializable()
class WorkingDateList {
  String? id;
  String? workingDate;
  String? startWorking;
  String? endWorking;
  String? startWorkingIMG;
  String? endWorkingIMG;
  String? status;
  String? contractID;
  String? title;
  String? fullName;
  String? address;
  String? phone;
  String? email;
  String? contractDetailID;
  String? timeWorking;
  String? note;
  String? startDate;
  String? endDate;
  String? expectedEndDate;
  double? totalPrice;
  String? plantStatus;
  String? plantIMG;
  String? serviceID;
  String? serviceName;
  String? serviceTypeID;
  String? typeName;
  int? typePercentage;
  String? typeSize;
  String? typeUnit;
  String? typeApplyDate;
  String? servicePackID;
  String? packRange;
  String? packUnit;
  int? packPercentage;
  String? packApplyDate;
  ShowStaffModel? showStaffModel;

  WorkingDateList({this.id,
    this.workingDate,
    this.startWorking,
    this.endWorking,
    this.startWorkingIMG,
    this.endWorkingIMG,
    this.status,
    this.contractID,
    this.title,
    this.fullName,
    this.address,
    this.phone,
    this.email,
    this.contractDetailID,
    this.timeWorking,
    this.note,
    this.startDate,
    this.endDate,
    this.expectedEndDate,
    this.totalPrice,
    this.plantStatus,
    this.plantIMG,
    this.serviceID,
    this.serviceName,
    this.serviceTypeID,
    this.typeName,
    this.typePercentage,
    this.typeSize,
    this.typeUnit,
    this.typeApplyDate,
    this.servicePackID,
    this.packRange,
    this.packUnit,
    this.packPercentage,
    this.packApplyDate,
    this.showStaffModel});
  factory WorkingDateList.fromJson(Map<String, dynamic> json) => _$WorkingDateListFromJson(json);

  Map<String, dynamic> toJson() => _$WorkingDateListToJson(this);
}

@JsonSerializable()
class PlantStatusIMGModelList {
  String? id;
  String? imgUrl;

  PlantStatusIMGModelList({this.id, this.imgUrl});
  factory PlantStatusIMGModelList.fromJson(Map<String, dynamic> json) => _$PlantStatusIMGModelListFromJson(json);

  Map<String, dynamic> toJson() => _$PlantStatusIMGModelListToJson(this);
}
