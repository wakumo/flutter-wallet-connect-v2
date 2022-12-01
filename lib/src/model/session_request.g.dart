// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionRequest _$SessionRequestFromJson(Map<String, dynamic> json) =>
    SessionRequest(
      id: json['id'] as String,
      method: json['method'] as String,
      chainId: json['chainId'] as String?,
      topic: json['topic'] as String,
      params: SessionRequest.fromParamsJson(json['params'] as String),
    );

Map<String, dynamic> _$SessionRequestToJson(SessionRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'method': instance.method,
      'chainId': instance.chainId,
      'topic': instance.topic,
      'params': instance.params,
    };
