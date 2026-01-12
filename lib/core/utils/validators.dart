class Validators {
  Validators._();

  static String? requiredField(String? value,
      {String message = 'Wajib diisi'}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? positiveNumber(num? value,
      {String message = 'Harus lebih dari 0'}) {
    if (value == null || value <= 0) {
      return message;
    }
    return null;
  }

  static String? maxLength(String? value, int length) {
    if (value != null && value.length > length) {
      return 'Maksimal $length karakter';
    }
    return null;
  }
}
