class Capitalize {
  static String firstLetterUppercase(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';
  
  static String firstLetterLowercase(String s) =>
      s.isNotEmpty ? '${s[0].toLowerCase()}${s.substring(1)}' : '';

  static String capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}' : '';
}