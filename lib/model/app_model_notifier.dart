import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tefilat_haderech/constants.dart';
import 'package:tefilat_haderech/model/prayer_parameters.dart';
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
  //requested permissions
  bool _requestedPermission = false;

  bool initialized = false;

  late SharedPreferences _prefs;

  //getters
  VoiceType getVoice() => _appVoice;
  ThemeData getTheme() => _appTheme;
  String getFilename() => _filename;
  String getLocale() => _locale;
  bool getRequestedPermission() => _requestedPermission;

  //init from sharedPrefs
  Future<void> initModel() async {
    if (!initialized) {
      initialized = true;
      _prefs = await SharedPreferences.getInstance();
      String defaultLocale = Platform.localeName;
      //"platform locale: $defaultLocale");
      if (defaultLocale.startsWith("en")) {
        defaultLocale = "en";
      } else if (defaultLocale.startsWith("he")) {
        defaultLocale = "he";
      } else {
        defaultLocale = "en";
      }

      _appTheme = (_prefs.getBool(Constants.isDarkTheme) ?? false)
          ? AppTheme.darkTheme()
          : AppTheme.lightTheme();
      _locale = (_prefs.getString(Constants.locale) ?? defaultLocale);
      _appVoice = VoiceType.values.firstWhere((element) =>
          element.name == (_prefs.getString(Constants.voiceType) ?? "female"));
      //print("appmodel $_appVoice");
      _filename = _prefs.getString(Constants.filename) ?? "";
      //print("initModel");
      _requestedPermission =
          _prefs.getBool(Constants.firstTimeUse) ?? false; //default to false
      print("initModel requested permission: $_requestedPermission");
      notifyListeners();

      //print("initmodel original ${prefs.getString(Constants.voiceType)}");
    }
  }

  //setters
  void toggleTheme() {
    _appTheme = (_appTheme == AppTheme.lightTheme())
        ? AppTheme.darkTheme()
        : AppTheme.lightTheme();
    _prefs.setBool(Constants.isDarkTheme, _appTheme == AppTheme.darkTheme());
    //print("togglettheme");

    notifyListeners();
  }

  void updateVoice(VoiceType newVoice) {
    //print("updateVoice appmodel: $newVoice");
    _appVoice = newVoice;

    _prefs.setString(Constants.voiceType, _appVoice.name);
    notifyListeners();
  }

  void updateLocale(AppLocale newLocale) {
    _locale = newLocale.name;
    _prefs.setString(Constants.locale, _locale);

    notifyListeners();
  }

  void updateFilename(String newFile) {
    _filename = newFile;
    _prefs.setString(Constants.filename, newFile);
    //print("updateFilename $_filename");
    notifyListeners();
  }

  void updateRequestedPermission(bool requested) {
    _requestedPermission = requested;
    _prefs.setBool(Constants.firstTimeUse, requested);
    print("updateRequestedPermission $requested");
    //notifyListeners();
  }

  PrayerParameters getPrayerParameters() {
    final String? jsonString = _prefs.getString(Constants.prayerParameters);
    if (jsonString != null && jsonString.isNotEmpty) {
      // Return default parameters if not set
      return PrayerParameters.fromJson(Map<String, dynamic>.from(
          (jsonDecode(jsonString) as Map<String, dynamic>)));
    }
    return PrayerParameters();
  }

  void updatePrayerParameters(PrayerParameters parameters) {
    _prefs.setString(Constants.prayerParameters, parameters.toJson());
  }
}
