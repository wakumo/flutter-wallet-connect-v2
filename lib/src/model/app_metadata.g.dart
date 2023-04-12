// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppMetadata _$AppMetadataFromJson(Map<String, dynamic> json) => AppMetadata(
      name: json['name'] as String,
      url: json['url'] as String,
      description: json['description'] as String,
      icons: (json['icons'] as List<dynamic>).map((e) => e as String).toList(),
      redirect: json['redirect'] as String?,
    );

Map<String, dynamic> _$AppMetadataToJson(AppMetadata instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'description': instance.description,
      'icons': instance.icons,
      'redirect': instance.redirect,
    };
