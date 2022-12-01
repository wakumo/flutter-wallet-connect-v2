// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      topic: json['topic'] as String,
      peer: AppMetadata.fromJson(json['peer'] as Map<String, dynamic>),
      expiration: Session.fromExpirationJson(json['expiration'] as String),
      namespaces: (json['namespaces'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, SessionNamespace.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'topic': instance.topic,
      'peer': instance.peer.toJson(),
      'expiration': instance.expiration.toIso8601String(),
      'namespaces': instance.namespaces.map((k, e) => MapEntry(k, e.toJson())),
    };
