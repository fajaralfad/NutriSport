class FormValidators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Masukkan nama Anda';
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Masukkan usia';
    }
    final age = int.tryParse(value);
    if (age == null || age <= 0) {
      return 'Usia tidak valid';
    }
    return null;
  }

  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Masukkan berat';
    }
    final weight = double.tryParse(value);
    if (weight == null || weight <= 0) {
      return 'Berat tidak valid';
    }
    return null;
  }

  static String? validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Masukkan tinggi';
    }
    final height = double.tryParse(value);
    if (height == null || height <= 0) {
      return 'Tinggi tidak valid';
    }
    return null;
  }
}