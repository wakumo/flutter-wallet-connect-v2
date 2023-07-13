import 'package:json_annotation/json_annotation.dart';

part 'session_namespace.g.dart';

@JsonSerializable(explicitToJson: true)
class SessionNamespace {
  @JsonKey(includeIfNull: false)
  final List<String>? chains;
  final List<String> accounts;
  final List<String> methods;
  final List<String> events;

  SessionNamespace(
      {required this.accounts,
      required this.methods,
      required this.events,
      this.chains});

  factory SessionNamespace.fromJson(Map<String, dynamic> json) =>
      _$SessionNamespaceFromJson(json);

  Map<String, dynamic> toJson() => _$SessionNamespaceToJson(this);
}
