import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Constants {
  //keys
  static String firstTimeUse = "firstTimeUse";
  static String prayerVersion = "prayerVersion";
  static String voiceType = "voiceType";
  static String isDarkTheme = "isDarkTheme";
  static String filename = "filename";
  static String locale = "he";
  //constants
  static const String femaleName = "תהילה";
  static const String maleName = "שמואל";
  static const String customName = "קובץ שלי";
  static const int alarmId = 42; //the answer to all questions.
}

enum VoiceType { female, male, custom }

enum PrayerType { ashkenaz, sepharad, edotMizrach }

enum ReturnToday { returnToday, notReturnToday }

enum AppLocale { he, en }

final Map<String, String> appLanguages = {
  AppLocale.en.name: "English",
  AppLocale.he.name: "Hebrew"
};

class Util {
  static VoiceType string2VoiceType(String voice) {
    if (voice == Constants.maleName) {
      return VoiceType.male;
    }
    if (voice == Constants.femaleName) {
      return VoiceType.female;
    }
    return VoiceType.custom;
  }

  static String voiceType2String(VoiceType voice, BuildContext context) {
    switch (voice) {
      case VoiceType.custom:
        return AppLocalizations.of(context)!.custom_name;
      case VoiceType.female:
        return AppLocalizations.of(context)!.female_name;
      case VoiceType.male:
        return AppLocalizations.of(context)!.male_name;
    }
  }
}
