import 'package:json_annotation/json_annotation.dart';

part 'session_response.g.dart';

@JsonSerializable(explicitToJson: true)
class SessionResponse {
  final String id;
  final String topic;
  dynamic results;

  SessionResponse({required this.id, required this.topic, this.results});

  factory SessionResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SessionResponseToJson(this);
}
