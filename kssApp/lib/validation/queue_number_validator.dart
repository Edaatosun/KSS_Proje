bool isInteger(String queueNumber) {
  try {
    int.parse(queueNumber);
    return true;
  } catch (e) {
    return false;
  }
}

mixin QueueNumberValidationMixin {
  String? validateQueueNumber(String? value) {
    if (value == null || value.isEmpty || !isInteger(value)) {
      return 'Sıra numarası sadece rakamlardan oluşabilir.';
    }
    return null;
  }
}
