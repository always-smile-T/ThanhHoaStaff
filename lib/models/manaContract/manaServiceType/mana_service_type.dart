import 'package:json_annotation/json_annotation.dart';
part 'mana_service_type.g.dart';

@JsonSerializable()

class ManaServiceType {
  String? id;
  String? name;
  String? size;
  String? unit;
  int? percentage;
  String? applyDate;
  String? serviceID;

  ManaServiceType(
      {this.id,
        this.name,
        this.size,
        this.unit,
        this.percentage,
        this.applyDate,
        this.serviceID});

  factory ManaServiceType.fromJson(Map<String, dynamic> json) => _$ManaServiceTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ManaServiceTypeToJson(this);
}