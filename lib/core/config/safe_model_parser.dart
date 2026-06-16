import 'package:json_annotation/json_annotation.dart';

class SafeModelParser<T> implements JsonConverter<T?, dynamic> {
  final T Function(Map<String, dynamic>) fromJsonT;

  const SafeModelParser(this.fromJsonT);

  @override
  T? fromJson(dynamic json) {
    if (json == null) return null;

    if (json is Map<String, dynamic>) {
      final isAllFieldsEmpty = json.values.every((value) {
        if (value == null) return true;
        if (value is String && value.trim().isEmpty) return true;
        if (value is Map && value.isEmpty) return true;
        return false;
      });

      if (isAllFieldsEmpty) return null;

      try {
        return fromJsonT(json);
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  @override
  dynamic toJson(T? object) {
    if (object == null) return null;
    try {
      return (object as dynamic).toJson();
    } catch (_) {
      return null;
    }
  }
}
