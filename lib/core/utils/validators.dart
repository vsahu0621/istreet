class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return "Please enter email";
    if (!value.contains("@")) return "Invalid email";
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return "Please enter password";
    if (value.length < 6) return "Minimum 6 characters";
    return null;
  }
}
