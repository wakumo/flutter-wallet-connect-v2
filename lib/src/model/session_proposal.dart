import 'package:json_annotation/json_annotation.dart';

import 'app_metadata.dart';
import 'proposal_namespace.dart';

part 'session_proposal.g.dart';

@JsonSerializable(explicitToJson: true)
class SessionProposal {
  final String id;
  final AppMetadata proposer;
  final Map<String, ProposalNamespace> namespaces;

  SessionProposal(
      {required this.id, required this.proposer, required this.namespaces});

  factory SessionProposal.fromJson(Map<String, dynamic> json) =>
      _$SessionProposalFromJson(json);

  Map<String, dynamic> toJson() => _$SessionProposalToJson(this);
}
