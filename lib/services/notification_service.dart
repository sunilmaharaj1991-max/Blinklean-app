import 'package:flutter/foundation.dart';

class NotificationService {
  Future<void> initialize() async {
    if (kDebugMode) {
      print('Supabase complete mode - NotificationService initialization skipped.');
    }
  }
}
