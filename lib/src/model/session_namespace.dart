import 'package:json_annotation/json_annotation.dart';

import 'extension.dart';

part 'session_namespace.g.dart';

@JsonSerializable(explicitToJson: true)
class SessionNamespace {
  final List<String> accounts;
  final List<String> methods;
  final List<String> events;
  final List<Extension>? extensions;

  SessionNamespace(
      {required this.accounts,
      required this.methods,
      required this.events,
      required this.extensions});

  factory SessionNamespace.fromJson(Map<String, dynamic> json) =>
      _$SessionNamespaceFromJson(json);

  Map<String, dynamic> toJson() => _$SessionNamespaceToJson(this);
}
