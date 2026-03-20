import 'package:flutter/material.dart';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    String errorStr = error.toString();

    if (errorStr.contains('SocketException') ||
        errorStr.contains('XMLHttpRequest error') ||
        errorStr.contains('ClientException')) {
      return 'Server connection failed. If you are in demo mode, please check your network or ensure the backend is running.';
    } else if (errorStr.contains('HttpException')) {
      return 'Server error. Please try again later.';
    } else if (errorStr.contains('FormatException')) {
      return 'Invalid response from server.';
    }

    return 'Something went wrong. Please try again.';
  }

  static void showError(BuildContext context, dynamic error) {
    final message = getErrorMessage(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
