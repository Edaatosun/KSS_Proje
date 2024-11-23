mixin MedicineValidationMixin {
  final minNameLength = 2;
  final maxNameLength = 15;

  String? validateMedicineName(String? value) {
    if (value == null || value.length < minNameLength || value.length > maxNameLength) {
      return 'İlaç ismi minumum $minNameLength, maximum $maxNameLength karakter barındırabilir.';
    }
    return null;
  }

  String? validateFrequency(String? value) {
    final timePattern = RegExp(
        //* max 3 alarm kuralı max 5 alarm ile değiştirildi
        // r'^(0?[0-9]|1[0-9]|2[0-3]):(0?[0-9]|[1-5][0-9])(,\s*(0?[0-9]|1[0-9]|2[0-3]):(0?[0-9]|[1-5][0-9])){0,2}$');
        r'^(0?[0-9]|1[0-9]|2[0-3]):(0?[0-9]|[1-5][0-9])(,\s*(0?[0-9]|1[0-9]|2[0-3]):(0?[0-9]|[1-5][0-9])){0,4}$');

    if (value == null || value.isEmpty) {
      return 'Lütfen bildirim almak istediğiniz saati seçin.';
    }
    if (!timePattern.hasMatch(value)) {
      return 'Lütfen saati 09:35, 16:00 formatında girin.(en fazla 5 adet)';
    }

    return null;
  }

  String? validateHungerSituation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen ilacın alınacağı açlık durumunu belirtin.';
    }
    return null;
  }
}
