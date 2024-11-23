mixin NurseCodeValidationMixin {
  String? validateNurseCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Hemşire kodu boş olamaz.';
    } else if (value.length != 6) {
      return 'Hemşire kodu 6 karakterli olmalıdır.';
    } else if (int.tryParse(value) == null) {
      return 'Hemşire kodu yalnızca sayılardan oluşmalıdır.';
    }
    return null;
  }
}
