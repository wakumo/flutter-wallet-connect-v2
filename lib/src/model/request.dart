import 'package:json_annotation/json_annotation.dart';

part 'request.g.dart';

@JsonSerializable(explicitToJson: true)
class Request {
  final String method;
  final String chainId;
  final String topic;
  final List<String> params;

  Request(
      {required this.method,
      required this.chainId,
      required this.topic,
      required this.params});

  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);

  Map<String, dynamic> toJson() => _$RequestToJson(this);
}
