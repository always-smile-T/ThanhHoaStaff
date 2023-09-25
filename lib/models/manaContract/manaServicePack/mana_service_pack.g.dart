// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mana_service_pack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManaServicePack _$ManaServicePackFromJson(Map<String, dynamic> json) =>
    ManaServicePack(
      id: json['id'],
      range: json['range'],
      unit: json['unit'],
      percentage: json['percentage'],
      applyDate: json['applyDate'],
      status: json['status'],
    );

Map<String, dynamic> _$ManaServicePackToJson(ManaServicePack instance) =>
    <String, dynamic>{
      'id': instance.id,
      'range': instance.range,
      'unit': instance.unit,
      'percentage': instance.percentage,
      'applyDate': instance.applyDate,
      'status': instance.status,
    };
