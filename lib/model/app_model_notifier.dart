import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tefilat_haderech/constants.dart';
import 'package:tefilat_haderech/styles.dart';

class AppModelNotifier extends ChangeNotifier {
  //app data
  //theme
  ThemeData _appTheme = AppTheme.lightTheme();
//female, male,custom
  VoiceType _appVoice = VoiceType.female;
  //file if custom
  String _filename = "";

  //getters
  VoiceType getVoice() => _appVoice;
  ThemeData getTheme() => _appTheme;
  String getFilename() => _filename;

  //init from sharedPrefs
  Future<void> initModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _appTheme = (prefs.getBool(Constants.isDarkTheme) ?? false)
        ? AppTheme.darkTheme()
        : AppTheme.lightTheme();
    _appVoice = (Util.string2VoiceType(
        prefs.getString(Constants.voiceType) ?? VoiceType.female.name));
    _filename = prefs.getString(Constants.filename) ?? "";
    notifyListeners();
  }

  //setters
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

  void updateVoice(VoiceType newVoice) {
    print("newVoice: $newVoice");
    _appVoice = newVoice;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setString(Constants.voiceType, _appVoice.name);
      },
    );
    notifyListeners();
  }

  void updateFilename(String newFile) {
    _filename = newFile;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setString(Constants.filename, newFile);
      },
    );
    print("newFile $_filename");
    notifyListeners();
  }
}
