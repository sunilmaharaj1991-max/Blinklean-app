import 'package:flutter/foundation.dart';

class NotificationService {
  Future<void> initialize() async {
    if (kDebugMode) {
      print('NotificationService initialization skipped (debug mode).');
    }
  }
}
