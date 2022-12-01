import 'package:json_annotation/json_annotation.dart';

import 'app_metadata.dart';
import 'session_namespace.dart';

part 'session.g.dart';

@JsonSerializable(explicitToJson: true)
class Session {
  final String topic;
  final AppMetadata peer;

  @JsonKey(fromJson: fromExpirationJson)
  final DateTime expiration;

  final Map<String, SessionNamespace> namespaces;

  Session(
      {required this.topic,
      required this.peer,
      required this.expiration,
      required this.namespaces});

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);

  static DateTime fromExpirationJson(String timestampInISO8601) {
    return DateTime.parse(timestampInISO8601).toLocal();
  }
}
