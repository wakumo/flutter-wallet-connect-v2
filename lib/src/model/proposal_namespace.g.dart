// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proposal_namespace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProposalNamespace _$ProposalNamespaceFromJson(Map<String, dynamic> json) =>
    ProposalNamespace(
      chains:
          (json['chains'] as List<dynamic>?)?.map((e) => e as String).toList(),
      methods:
          (json['methods'] as List<dynamic>).map((e) => e as String).toList(),
      events:
          (json['events'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ProposalNamespaceToJson(ProposalNamespace instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('chains', instance.chains);
  val['methods'] = instance.methods;
  val['events'] = instance.events;
  return val;
}
