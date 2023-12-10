import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool(Constants.isDarkTheme, _appTheme == AppTheme.darkTheme());
      },
    );

    notifyListeners();
  }

  Future<void> updateModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _appTheme = (prefs.getBool(Constants.isDarkTheme) ?? false)
        ? AppTheme.darkTheme()
        : AppTheme.lightTheme();
    _appVoice =
        ((prefs.getString(Constants.voiceType) ?? VoiceType.female.name) ==
                VoiceType.female.name)
            ? VoiceType.female
            : VoiceType.male;
    notifyListeners();
  }

  void updateVoice(VoiceType newVoice) {
    _appVoice = newVoice;
    notifyListeners();
  }
}
