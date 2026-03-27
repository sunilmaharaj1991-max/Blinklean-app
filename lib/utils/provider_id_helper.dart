import 'dart:math';

class ProviderIdHelper {
  static final Random _random = Random();
  static const List<String> _specialChars = ['@', '#', '\$', '&', '*', '!', '%'];

  static String generate(String name) {
    String sanitizedName = name
        .trim()
        .split(' ')
        .first
        .replaceAll(RegExp(r'[^a-zA-Z]'), '')
        .toUpperCase();

    if (sanitizedName.isEmpty) {
      sanitizedName = 'USER';
    }

    final String digits = _nonStaticGenerateDigits();
    final String special = _nonStaticGetSpecialChar();

    return '${sanitizedName}_$digits$special';
  }

  static String _nonStaticGenerateDigits() {
    final int val = _random.nextInt(9000) + 1000;
    return val.toString();
  }

  static String _nonStaticGetSpecialChar() {
    return _specialChars[_random.nextInt(_specialChars.length)];
  }
}
