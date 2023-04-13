// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Request _$RequestFromJson(Map<String, dynamic> json) => Request(
      method: json['method'] as String,
      chainId: json['chainId'] as String,
      topic: json['topic'] as String,
      params: json['params'],
    );

Map<String, dynamic> _$RequestToJson(Request instance) => <String, dynamic>{
      'method': instance.method,
      'chainId': instance.chainId,
      'topic': instance.topic,
      'params': instance.params,
    };
