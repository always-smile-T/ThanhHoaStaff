// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Noty _$NotyFromJson(Map<String, dynamic> json) => Noty(
      id: json['id'] as String?,
      title: json['title'] as String?,
      link: json['link'] as String?,
      description: json['description'] as String?,
      isRead: json['isRead'] as bool?,
      date: json['date'] as String?,
    );

Map<String, dynamic> _$NotyToJson(Noty instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'link': instance.link,
      'description': instance.description,
      'isRead': instance.isRead,
      'date': instance.date,
    };
