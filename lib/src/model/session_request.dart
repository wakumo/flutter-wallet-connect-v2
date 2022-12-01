import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'session_request.g.dart';

@JsonSerializable(explicitToJson: true)
class SessionRequest {
  final String id;
  final String method;
  final String? chainId;
  final String topic;

  @JsonKey(fromJson: fromParamsJson)
  final List<dynamic> params;

  SessionRequest(
      {required this.id,
      required this.method,
      this.chainId,
      required this.topic,
      required this.params});

  factory SessionRequest.fromJson(Map<String, dynamic> json) =>
      _$SessionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SessionRequestToJson(this);

  static List<dynamic> fromParamsJson(String json) {
    return jsonDecode(json) as List;
  }
}
