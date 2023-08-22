import 'package:json_annotation/json_annotation.dart';
part 'notification.g.dart';

@JsonSerializable()

class Noty {
  String? id;
  String? title;
  String? link;
  String? description;
  bool? isRead;
  String? date;

  Noty(
      {this.id,
        this.title,
        this.link,
        this.description,
        this.isRead,
        this.date});

  factory Noty.fromJson(Map<String, dynamic> json) => _$NotyFromJson(json);

  Map<String, dynamic> toJson() => _$NotyToJson(this);
}