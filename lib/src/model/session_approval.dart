import 'package:json_annotation/json_annotation.dart';

import 'session_namespace.dart';

part 'session_approval.g.dart';

@JsonSerializable(explicitToJson: true)
class SessionApproval {
  final String id;
  final Map<String, SessionNamespace> namespaces;

  SessionApproval({required this.id, required this.namespaces});

  factory SessionApproval.fromJson(Map<String, dynamic> json) =>
      _$SessionApprovalFromJson(json);

  Map<String, dynamic> toJson() => _$SessionApprovalToJson(this);
}
