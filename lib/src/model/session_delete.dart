import 'package:json_annotation/json_annotation.dart';

part 'session_delete.g.dart';

@JsonSerializable(explicitToJson: true)
class SessionDelete {
  final String topic;

  SessionDelete(this.topic);

  factory SessionDelete.fromJson(Map<String, dynamic> json) =>
      _$SessionDeleteFromJson(json);

  Map<String, dynamic> toJson() => _$SessionDeleteToJson(this);
}
