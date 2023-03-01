import 'package:json_annotation/json_annotation.dart';

part 'session_rejection.g.dart';

@JsonSerializable(explicitToJson: true)
class SessionRejection {
  final String topic;

  SessionRejection(this.topic);

  factory SessionRejection.fromJson(Map<String, dynamic> json) =>
      _$SessionRejectionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionRejectionToJson(this);
}