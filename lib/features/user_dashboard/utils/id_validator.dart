// lib/utils/id_validator.dart

class IdValidator {
  static bool isValidSouthAfricanId(String id) {
    if (id.length != 13) return false;

    try {
      // Check date format (YYMMDD)
      int.parse(id.substring(0, 2));
      int month = int.parse(id.substring(2, 4));
      int day = int.parse(id.substring(4, 6));

      if (month < 1 || month > 12) return false;
      if (day < 1 || day > 31) return false;

      // Validate checksum using Luhn algorithm
      int sum = 0;
      bool alternate = false;

      for (int i = id.length - 1; i >= 0; i--) {
        int n = int.parse(id[i]);
        if (alternate) {
          n *= 2;
          if (n > 9) n = (n % 10) + 1;
        }
        sum += n;
        alternate = !alternate;
      }

      return sum % 10 == 0;
    } catch (e) {
      return false;
    }
  }
}