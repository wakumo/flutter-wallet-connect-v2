// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_proposal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionProposal _$SessionProposalFromJson(Map<String, dynamic> json) =>
    SessionProposal(
      id: json['id'] as String,
      proposer: AppMetadata.fromJson(json['proposer'] as Map<String, dynamic>),
      namespaces: (json['namespaces'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, ProposalNamespace.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$SessionProposalToJson(SessionProposal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'proposer': instance.proposer.toJson(),
      'namespaces': instance.namespaces.map((k, e) => MapEntry(k, e.toJson())),
    };
