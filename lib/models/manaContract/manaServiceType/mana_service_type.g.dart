// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mana_service_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManaServiceType _$ManaServiceTypeFromJson(Map<String, dynamic> json) =>
    ManaServiceType(
      id: json['id'] as String?,
      name: json['name'] as String?,
      size: json['size'] as String?,
      unit: json['unit'] as String?,
      percentage: json['percentage'] as int?,
      applyDate: json['applyDate'] as String?,
      serviceID: json['serviceID'] as String?,
    );

Map<String, dynamic> _$ManaServiceTypeToJson(ManaServiceType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'size': instance.size,
      'unit': instance.unit,
      'percentage': instance.percentage,
      'applyDate': instance.applyDate,
      'serviceID': instance.serviceID,
    };
