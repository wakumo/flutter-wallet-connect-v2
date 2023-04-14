import 'package:json_annotation/json_annotation.dart';

part 'session_update.g.dart';

@JsonSerializable(explicitToJson: true)
class SessionUpdate {
  final String topic;

  SessionUpdate(this.topic);

  factory SessionUpdate.fromJson(Map<String, dynamic> json) =>
      _$SessionUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$SessionUpdateToJson(this);
}
