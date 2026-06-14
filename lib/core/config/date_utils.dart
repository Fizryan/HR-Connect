class ApiDateUtils {
  ApiDateUtils._();

  static String? parseApiDate(dynamic date) {
    if (date == null) return null;

    if (date is int) {
      if (date < 100000000000) {
        return DateTime.fromMillisecondsSinceEpoch(
          date * 1000,
        ).toIso8601String();
      }
      return DateTime.fromMillisecondsSinceEpoch(date).toIso8601String();
    }

    if (date is String) {
      final asInt = int.tryParse(date);
      if (asInt != null) {
        return parseApiDate(asInt);
      }
      return date;
    }
    return null;
  }

  static String dateToApiString(DateTime date) {
    return (date.millisecondsSinceEpoch ~/ 1000).toString();
  }

  static DateTime parseToDateTime(dynamic date) {
    final isoString = parseApiDate(date);

    if (isoString != null) {
      return DateTime.parse(isoString);
    }

    return DateTime.now();
  }
}
