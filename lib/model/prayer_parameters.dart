import 'dart:convert';

import 'package:tefilat_haderech/constants.dart';

class PrayerParameters {
  ReturnToday returnToday = ReturnToday.returnToday;
  VoiceType voiceType = VoiceType.female;
  Duration time = const Duration(minutes: 30);
  PrayerType prayerType = PrayerType.ashkenaz;
  double volume = 1.0;

  PrayerParameters();

  void setTime(int minutes) {
    time = Duration(minutes: minutes);
  }

  @override
  String toString() {
    return "$returnToday $voiceType $time $prayerType";
  }

  String toJson() {
    return jsonEncode({
      "returnToday": returnToday.name,
      "voiceType": voiceType.name,
      "time": time.inMinutes,
      "prayerType": prayerType.name,
      "volume": volume,
    });
  }

  PrayerParameters.fromJson(Map<String, dynamic> json) {
    returnToday = ReturnToday.values.firstWhere(
        (e) => e.name == json["returnToday"],
        orElse: () => ReturnToday.returnToday);
    voiceType = VoiceType.values.firstWhere((e) => e.name == json["voiceType"],
        orElse: () => VoiceType.female);
    time = Duration(minutes: json["time"] ?? 30);
    prayerType = PrayerType.values.firstWhere(
        (e) => e.name == json["prayerType"],
        orElse: () => PrayerType.ashkenaz);
    volume = json["volume"]?.toDouble() ?? 1.0;
  }
}
