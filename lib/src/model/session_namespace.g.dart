// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_namespace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionNamespace _$SessionNamespaceFromJson(Map<String, dynamic> json) =>
    SessionNamespace(
      accounts:
          (json['accounts'] as List<dynamic>).map((e) => e as String).toList(),
      methods:
          (json['methods'] as List<dynamic>).map((e) => e as String).toList(),
      events:
          (json['events'] as List<dynamic>).map((e) => e as String).toList(),
      extensions: (json['extensions'] as List<dynamic>?)
          ?.map((e) => Extension.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SessionNamespaceToJson(SessionNamespace instance) =>
    <String, dynamic>{
      'accounts': instance.accounts,
      'methods': instance.methods,
      'events': instance.events,
      'extensions': instance.extensions?.map((e) => e.toJson()).toList(),
    };
