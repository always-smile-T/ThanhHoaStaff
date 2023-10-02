import 'package:json_annotation/json_annotation.dart';
part 'schedule_today.g.dart';


@JsonSerializable()
class WorkingInSchedule {
  String? id;
  String? workingDate;
  String? startWorking;
  String? endWorking;
  String? startWorkingIMG;
  String? endWorkingIMG;
  bool? isReported;
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
  String? plantName;
  String? serviceID;
  String? serviceName;
  String? serviceTypeID;
  String? typeName;
  int? typePercentage;
  String? typeSize;
  String? typeApplyDate;
  String? servicePackID;
  String? packRange;
  int? packPercentage;
  String? packApplyDate;
  ShowStaffModel? showStaffModel;

  WorkingInSchedule(
      {this.id,
        this.workingDate,
        this.startWorking,
        this.endWorking,
        this.startWorkingIMG,
        this.endWorkingIMG,
        this.isReported,
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
        this.plantName,
        this.serviceID,
        this.serviceName,
        this.serviceTypeID,
        this.typeName,
        this.typePercentage,
        this.typeSize,
        this.typeApplyDate,
        this.servicePackID,
        this.packRange,
        this.packPercentage,
        this.packApplyDate,
        this.showStaffModel});
  factory WorkingInSchedule.fromJson(Map<String, dynamic> json) => _$WorkingInScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$WorkingInScheduleToJson(this);
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
  int? totalPage;

  ShowStaffModel(
      {this.fullName,
        this.email,
        this.phone,
        this.address,
        this.id,
        this.avatar,
        this.gender,
        this.status,
        this.totalPage});
  factory ShowStaffModel.fromJson(Map<String, dynamic> json) => _$ShowStaffModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShowStaffModelToJson(this);
}
