class Validator {
  static String? emailValidator(String? email) {
    if (email != null) {
      if (email.trim().isEmpty) return 'Email is required';
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email.trim())) {
        return 'Please enter a valid email address';
      }
    }
    return null;
  }

  static String? passwordValidator(String? password) {
    if (password != null) {
      if (password.trim().isEmpty) {
        return 'Password is required';
      }
      if (password.length < 8) return 'Password must be at least 8 characters';
      if (!password.contains(RegExp(r'[A-Z]'))) {
        return 'Must contain at least one uppercase letter';
      }
      if (!password.contains(RegExp(r'[0-9]'))) {
        return 'Must contain at least one number';
      }
      if (!password.contains(RegExp(r'[^a-zA-Z0-9\s]'))) {
        return 'Must contain at least one symbol';
      }
    }
    return null;
  }

  static String? requiredValidator(String? value) {
    if (value != null) {
      if (value.trim().isEmpty) return 'This field is required';
    }
    return null;
  }
}
