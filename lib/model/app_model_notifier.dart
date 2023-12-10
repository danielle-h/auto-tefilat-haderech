import 'package:flutter/material.dart';
import 'package:tefilat_haderech/constants.dart';
import 'package:tefilat_haderech/styles.dart';

class AppModelNotifier extends ChangeNotifier {
  ThemeData _appTheme = AppTheme.lightTheme();

  VoiceType _appVoice = VoiceType.female;

  VoiceType getVoice() => _appVoice;

  ThemeData getTheme() => _appTheme;

  void toggleTheme() {
    _appTheme = (_appTheme == AppTheme.lightTheme())
        ? AppTheme.darkTheme()
        : AppTheme.lightTheme();
    notifyListeners();
  }

  void updateVoice(VoiceType newVoice) {
    _appVoice = newVoice;
    notifyListeners();
  }
}
