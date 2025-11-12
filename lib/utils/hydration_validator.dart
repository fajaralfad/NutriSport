class HydrationValidator {
  static bool validateInputs(String weight, String duration) {
    return weight.isNotEmpty && duration.isNotEmpty;
  }

  static double? parseDouble(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      return null;
    }
  }
}