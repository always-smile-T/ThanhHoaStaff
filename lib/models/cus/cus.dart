import 'package:json_annotation/json_annotation.dart';
part 'cus.g.dart';

@JsonSerializable()
class Cus {
  int? userID;
  String? userName;
  String? fullName;
  String? email;
  String? phone;
  String? avatar;
  String? address;
  bool? gender;
  String? status;
  String? createdDate;
  String? roleID;
  String? roleName;

  Cus(
      {this.userID,
        this.userName,
        this.fullName,
        this.email,
        this.phone,
        this.avatar,
        this.address,
        this.gender,
        this.status,
        this.createdDate,
        this.roleID,
        this.roleName});

  factory Cus.fromJson(Map<String, dynamic> json) => _$CusFromJson(json);

  Map<String, dynamic> toJson() => _$CusToJson(this);
}