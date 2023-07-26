import 'package:json_annotation/json_annotation.dart';
part 'contract.g.dart';

@JsonSerializable()
class Contract {
  String? id;
  String? title;
  String? fullName;
  String? email;
  String? phone;
  String? address;
  String? paymentMethod;
  String? reason;
  String? createdDate;
  String? startedDate;
  String? endedDate;
  String? approvedDate;
  String? rejectedDate;
  double? deposit;
  double? total;
  bool? isFeedback;
  bool? isSigned;
  String? status;
  List<ImgList>? imgList;
  ShowStaffModel? showStaffModel;
  ShowCustomerModel? showCustomerModel;
  ShowStoreModel? showStoreModel;
  ShowPaymentTypeModel? showPaymentTypeModel;
  late final totalPage;

  Contract(
      {this.id,
        this.title,
        this.fullName,
        this.email,
        this.phone,
        this.address,
        this.paymentMethod,
        this.reason,
        this.createdDate,
        this.startedDate,
        this.endedDate,
        this.approvedDate,
        this.rejectedDate,
        this.deposit,
        this.total,
        this.isFeedback,
        this.isSigned,
        this.status,
        this.imgList,
        this.showStaffModel,
        this.showCustomerModel,
        this.showStoreModel,
        this.showPaymentTypeModel,
        this.totalPage
      });

  factory Contract.fromJson(Map<String, dynamic> json) => _$ContractFromJson(json);

  Map<String, dynamic> toJson() => _$ContractToJson(this);
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

  ShowStaffModel(
      {this.fullName, this.email, this.phone, this.address, this.id});
  factory ShowStaffModel.fromJson(Map<String, dynamic> json) => _$ShowStaffModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShowStaffModelToJson(this);
}

@JsonSerializable()
class ShowCustomerModel {
  String? fullName;
  String? email;
  String? phone;
  String? address;
  int? id;

  ShowCustomerModel(
      {this.fullName, this.email, this.phone, this.address, this.id});

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
class ShowPaymentTypeModel {
  String? id;
  String? name;
  int? value;

  ShowPaymentTypeModel({this.id, this.name, this.value});

  factory ShowPaymentTypeModel.fromJson(Map<String, dynamic> json) => _$ShowPaymentTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShowPaymentTypeModelToJson(this);
}

