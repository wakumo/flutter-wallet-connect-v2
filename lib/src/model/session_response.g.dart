// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionResponse _$SessionResponseFromJson(Map<String, dynamic> json) =>
    SessionResponse(
      id: json['id'] as String,
      topic: json['topic'] as String,
      results: SessionResponse.fromResultsJson(json['results'] as String),
    );

Map<String, dynamic> _$SessionResponseToJson(SessionResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topic': instance.topic,
      'results': instance.results,
    };
