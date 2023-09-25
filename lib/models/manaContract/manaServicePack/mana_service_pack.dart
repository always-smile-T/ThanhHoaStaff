import 'package:json_annotation/json_annotation.dart';
part 'mana_service_pack.g.dart';

@JsonSerializable()

class ManaServicePack {
  late final id;
  late final range;
  late final unit;
  late final percentage;
  late final applyDate;
  late final status;

  ManaServicePack(
      {this.id,
        this.range,
        this.unit,
        this.percentage,
        this.applyDate,
        this.status});

  factory ManaServicePack.fromJson(Map<String, dynamic> json) => _$ManaServicePackFromJson(json);

  Map<String, dynamic> toJson() => _$ManaServicePackToJson(this);
}