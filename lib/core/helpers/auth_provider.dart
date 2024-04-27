//make a provider for bottom navigation bar
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider with ChangeNotifier, DiagnosticableTreeMixin  {
//determine is it fullscreen to close the bottom navigation bar
  bool _isRegistering = false;
  bool get isRegistering => _isRegistering;
  void setRegistering(bool value) {
    _isRegistering = value;
    notifyListeners();
  }
}