// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_approval.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionApproval _$SessionApprovalFromJson(Map<String, dynamic> json) =>
    SessionApproval(
      id: json['id'] as String,
      namespaces: (json['namespaces'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, SessionNamespace.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$SessionApprovalToJson(SessionApproval instance) =>
    <String, dynamic>{
      'id': instance.id,
      'namespaces': instance.namespaces.map((k, e) => MapEntry(k, e.toJson())),
    };
