import 'package:json_annotation/json_annotation.dart';

part 'extension.g.dart';

@JsonSerializable(explicitToJson: true)
class Extension {
  final List<String> chains;
  final List<String> methods;
  final List<String> events;

  Extension(
      {required this.chains, required this.methods, required this.events});

  factory Extension.fromJson(Map<String, dynamic> json) =>
      _$ExtensionFromJson(json);

  Map<String, dynamic> toJson() => _$ExtensionToJson(this);
}
