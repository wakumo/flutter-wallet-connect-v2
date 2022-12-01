import 'package:json_annotation/json_annotation.dart';

import 'extension.dart';

part 'proposal_namespace.g.dart';

@JsonSerializable(explicitToJson: true)
class ProposalNamespace {
  final List<String> chains;
  final List<String> methods;
  final List<String> events;
  final List<Extension>? extensions;

  ProposalNamespace(
      {required this.chains,
      required this.methods,
      required this.events,
      required this.extensions});

  factory ProposalNamespace.fromJson(Map<String, dynamic> json) =>
      _$ProposalNamespaceFromJson(json);

  Map<String, dynamic> toJson() => _$ProposalNamespaceToJson(this);
}
