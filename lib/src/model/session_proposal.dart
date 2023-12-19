import 'package:json_annotation/json_annotation.dart';

import 'app_metadata.dart';
import 'proposal_namespace.dart';

part 'session_proposal.g.dart';

@JsonSerializable(explicitToJson: true)
class SessionProposal {
  final String id;
  final AppMetadata proposer;
  final Map<String, ProposalNamespace>? namespaces;
  @JsonKey(includeIfNull: false)
  final Map<String, ProposalNamespace>? optionalNamespaces;

  SessionProposal(
      {required this.id,
      required this.proposer,
      required this.namespaces,
      this.optionalNamespaces});

  factory SessionProposal.fromJson(Map<String, dynamic> json) =>
      _$SessionProposalFromJson(json);

  Map<String, dynamic> toJson() => _$SessionProposalToJson(this);
}
