import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  String? _currentPincode;
  bool _isServiceAvailable = false;
  String? _areaName;

  String? get currentPincode => _currentPincode;
  bool get isServiceAvailable => _isServiceAvailable;
  String? get areaName => _areaName;

  void setLocation(String pincode, bool available, String? area) {
    _currentPincode = pincode;
    _isServiceAvailable = available;
    _areaName = area;
    notifyListeners();
  }

  void clearLocation() {
    _currentPincode = null;
    _isServiceAvailable = false;
    _areaName = null;
    notifyListeners();
  }
}
