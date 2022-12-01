import 'package:json_annotation/json_annotation.dart';

part 'app_metadata.g.dart';

@JsonSerializable(explicitToJson: true)
class AppMetadata {
  final String name;
  final String url;
  final String description;
  final List<String> icons;

  AppMetadata(
      {required this.name,
      required this.url,
      required this.description,
      required this.icons});

  factory AppMetadata.fromJson(Map<String, dynamic> json) =>
      _$AppMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$AppMetadataToJson(this);
}
