import 'package:json_annotation/json_annotation.dart';
part 'report.g.dart';

@JsonSerializable()
class Report {
  String? id;
  String? description;
  String? reason;
  String? status;
  String? createdDate;
  String? contractDetailID;
  String? serviceTypeID;
  String? serviceTypeName;
  String? serviceID;
  String? serviceName;
  int? customerID;
  String? fullName;
  String? phone;
  String? email;
  int? staffID;
  String? staffName;
  String? contractID;
  String? timeWorking;
  late final totalPage;

  Report(
      {this.id,
        this.description,
        this.reason,
        this.status,
        this.createdDate,
        this.contractDetailID,
        this.serviceTypeID,
        this.serviceTypeName,
        this.serviceID,
        this.serviceName,
        this.customerID,
        this.fullName,
        this.phone,
        this.email,
        this.staffID,
        this.staffName,
        this.contractID,
        this.timeWorking,
        this.totalPage});
  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

  Map<String, dynamic> toJson() => _$ReportToJson(this);

}