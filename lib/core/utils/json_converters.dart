import 'package:json_annotation/json_annotation.dart';

class DateTimeIsoConverter extends JsonConverter<DateTime, String> {
  const DateTimeIsoConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json).toLocal();

  @override
  String toJson(DateTime object) => object.toUtc().toIso8601String();
}
