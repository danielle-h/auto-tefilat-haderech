import 'package:tefilat_haderech/constants.dart';

class PrayerParameters {
  ReturnToday returnToday = ReturnToday.returnToday;
  VoiceType voiceType = VoiceType.female;
  Duration time = const Duration(minutes: 30);
  PrayerType prayerType = PrayerType.ashkenaz;
  bool maxVolume = false;

  void setTime(int minutes) {
    time = Duration(minutes: minutes);
  }

  @override
  String toString() {
    return "$returnToday $voiceType $time $prayerType";
  }
}
