class Constants {
  //keys
  static String firstTimeUse = "firstTimeUse";
  static String prayerVersion = "prayerVersion";
  static String voiceType = "voiceType";
  static String isDarkTheme = "isDarkTheme";
  //constants
  static const String femaleName = "תהילה";
  static const String maleName = "שמואל";
  static const String customName = "קובץ";
  static const int alarmId = 42; //the answer to all questions.
}

enum VoiceType { female, male, custom }

enum PrayerType { ashkenaz, sepharad, edotMizrach }

enum ReturnToday { returnToday, notReturnToday }

class Util {
  static VoiceType string2VoiceType(String voice) {
    if (voice.contains("custom")) {
      return VoiceType.custom;
    }
    if (voice == Constants.femaleName) {
      return VoiceType.female;
    }
    return VoiceType.male;
  }

  static String voiceType2String(VoiceType voice) {
    switch (voice) {
      case VoiceType.custom:
        return Constants.customName;
      case VoiceType.female:
        return Constants.femaleName;
      case VoiceType.male:
        return Constants.maleName;
    }
  }
}
