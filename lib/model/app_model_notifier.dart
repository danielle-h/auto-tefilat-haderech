import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tefilat_haderech/constants.dart';
import 'package:tefilat_haderech/styles.dart';

class AppModelProvider extends ChangeNotifier {
  //app data
  //theme
  ThemeData _appTheme = AppTheme.lightTheme();
//female, male,custom
  VoiceType _appVoice = VoiceType.female;
  //file if custom
  String _filename = "";
  //language
  String _locale = "he";

  bool initialized = false;

  //getters
  VoiceType getVoice() => _appVoice;
  ThemeData getTheme() => _appTheme;
  String getFilename() => _filename;
  String getLocale() => _locale;

  //init from sharedPrefs
  Future<void> initModel() async {
    if (!initialized) {
      initialized = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String defaultLocale = Platform.localeName;
      print("platform locale: $defaultLocale");
      if (defaultLocale.startsWith("en")) {
        defaultLocale = "en";
      } else if (defaultLocale.startsWith("he")) {
        defaultLocale = "he";
      } else {
        defaultLocale = "en";
      }

      _appTheme = (prefs.getBool(Constants.isDarkTheme) ?? false)
          ? AppTheme.darkTheme()
          : AppTheme.lightTheme();
      _locale = (prefs.getString(Constants.locale) ?? defaultLocale);
      _appVoice = VoiceType.values.firstWhere((element) =>
          element.name == (prefs.getString(Constants.voiceType) ?? "female"));
      print("appmodel $_appVoice");
      _filename = prefs.getString(Constants.filename) ?? "";
      print("initModel");
      notifyListeners();

      print("initmodel original ${prefs.getString(Constants.voiceType)}");
    }
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
    print("togglettheme");

    notifyListeners();
  }

  void updateVoice(VoiceType newVoice) {
    print("updateVoice appmodel: $newVoice");
    _appVoice = newVoice;
    notifyListeners();

    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setString(Constants.voiceType, _appVoice.name);
        print("appmodel saving $_appVoice");
      },
    );
  }

  void updateLocale(AppLocale newLocale) {
    _locale = newLocale.name;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setString(Constants.locale, _locale);
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
    print("updateFilename $_filename");
    notifyListeners();
  }
}
