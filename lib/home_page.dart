import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tefilat_haderech/alarm_params_page.dart';
import 'package:tefilat_haderech/prayer_parameters.dart';
import 'package:tefilat_haderech/prayer_version_selection.dart';
import 'package:tefilat_haderech/styles.dart';

import 'constants.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.prayerType});
  final PrayerType prayerType;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final player = AudioPlayer();
  bool isPlaying = false;
  bool returnToday = true;
  bool alarmExists = false;

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  Future<void> initPlayer() async {
    await player.setAsset("assets/sounds/ashkenaz-female-notReturnToday.mp3");
    print("loop mode: ${player.loopMode}");
    player.playerStateStream.listen((playerState) {
      print("playerstate: ${playerState.processingState}");
      if (playerState.processingState == ProcessingState.completed) {
        setState(() {
          isPlaying = false;
        });
      }
    });
    AlarmSettings? previousAlarm = Alarm.getAlarm(Constants.alarmId);
    if (previousAlarm != null) {
      setState(() {
        alarmExists = true;
      });
    }
    //player.set
  }

  final String ashkenaz_returnToday =
      "יְהִי רָצוֹן מִלְפָנֶיךָ יי אֱלֹהֵינוּ וֵאלֹהֵי אֲבוֹתֵינוּ, שֶׁתּוֹלִיכֵנוּ לְשָׁלוֹם וְתַצְעִידֵנוּ לְשָׁלוֹם וְתַדְרִיכֵנוּ לְשָׁלוֹם, וְתִסְמְכֵנוּ לְשָׁלוֹם, וְתַגִּיעֵנוּ לִמְחוֹז חֶפְצֵנוּ לְחַיִּים וּלְשִׂמְחָה וּלְשָׁלוֹם וְתַחְזִירֵנוּ לְשָׁלוֹם וְתַצִּילֵנוּ מִכַּף כָּל אוֹיֵב וְאוֹרֵב וְלִסְטִים וְחַיּוֹת רָעוֹת בַּדֶּרֶךְ, וּמִכָּל מִינֵי פֻּרְעָנֻיּוֹת הַמִּתְרַגְּשׁוֹת לָבוֹא לָעוֹלָם, וְתִתְּנֵנוּ לְחֵן וּלְחֶסֶד וּלְרַחֲמִים בְּעֵינֶיךָ וּבְעֵינֵי כָל רֹאֵינוּ, כִּי אל שׁוֹמֵעַ תְּפִלָּה וְתַחֲנוּן אַתָּה. בָּרוּךְ אַתָּה יי שׁוֹמֵעַ תְּפִלָּה";

  final String ashkenaz_notReturnToday =
      "יְהִי רָצוֹן מִלְפָנֶיךָ יי אֱלֹהֵינוּ וֵאלֹהֵי אֲבוֹתֵינוּ, שֶׁתּוֹלִיכֵנוּ לְשָׁלוֹם וְתַצְעִידֵנוּ לְשָׁלוֹם וְתַדְרִיכֵנוּ לְשָׁלוֹם, וְתִסְמְכֵנוּ לְשָׁלוֹם, וְתַגִּיעֵנוּ לִמְחוֹז חֶפְצֵנוּ לְחַיִּים וּלְשִׂמְחָה וּלְשָׁלוֹם וְתַצִּילֵנוּ מִכַּף כָּל אוֹיֵב וְאוֹרֵב וְלִסְטִים וְחַיּוֹת רָעוֹת בַּדֶּרֶךְ, וּמִכָּל מִינֵי פֻּרְעָנֻיּוֹת הַמִּתְרַגְּשׁוֹת לָבוֹא לָעוֹלָם, וְתִתְּנֵנוּ לְחֵן וּלְחֶסֶד וּלְרַחֲמִים בְּעֵינֶיךָ וּבְעֵינֵי כָל רֹאֵינוּ, כִּי אל שׁוֹמֵעַ תְּפִלָּה וְתַחֲנוּן אַתָּה. בָּרוּךְ אַתָּה יי שׁוֹמֵעַ תְּפִלָּה";

  void readAloud() {
    if (!isPlaying) {
      setState(() {
        isPlaying = true;
      });
      print("loop mode: ${player.loopMode}");
      player.seek(Duration.zero);

      player.play();
    }
  }

  void stop() {
    if (isPlaying) {
      player.stop();
      setState(() {
        isPlaying = false;
      });
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('תפילת הדרך-אשכנז'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              "תפילת הדרך",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  returnToday ? ashkenaz_returnToday : ashkenaz_notReturnToday,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "חוזרים היום?",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Switch(
                  value: returnToday,
                  onChanged: (value) async {
                    setState(() {
                      returnToday = value;
                    });
                    if (returnToday) {
                      await player.setAsset(
                          "assets/sounds/ashkenaz-female-returnToday.mp3");
                    } else {
                      await player.setAsset(
                          "assets/sounds/ashkenaz-female-notReturnToday.mp3");
                    }
                  }),
            ],
          ),
          Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                alarmExists
                    ? ElevatedButton(
                        onPressed: () async {
                          bool success = await Alarm.stop(Constants.alarmId);
                          if (success) {
                            setState(() {
                              alarmExists = false;
                            });
                          }
                          if (mounted) {
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("תפילה בוטלה בהצלחה")));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("ביטול תפילה נכשל")));
                            }
                          }
                        },
                        child: Text('לבטל תפילה'),
                        // style: ButtonStyle(
                        //   backgroundColor: MaterialStateProperty.all(
                        //       AppTheme.lightTheme().primaryColor),
                        //   foregroundColor: MaterialStateProperty.all(Colors.white),
                        // ),
                      )
                    : const SizedBox.shrink(),
                ElevatedButton(
                  onPressed: () {
                    isPlaying ? stop() : readAloud();
                  },
                  child: isPlaying ? Text("לעצור") : Text('לקרא עכשיו'),
                  // style: ButtonStyle(
                  //   backgroundColor: MaterialStateProperty.all(
                  //       AppTheme.lightTheme().primaryColor),
                  //   foregroundColor: MaterialStateProperty.all(Colors.white),
                  // ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    PrayerParameters? parameters = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AlarmParametersPage()));
                    if (parameters == null) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("תפילה לא נקבעה")));
                      }
                      return;
                    }
                    print(parameters);
                    String filename =
                        "${parameters.prayerType.name}-${parameters.voiceType.name}-${parameters.returnToday.name}.mp3";
                    //TODO use parameters to set alarm
                    //TODO need option to cancel
                    final alarmSettings = AlarmSettings(
                      id: Constants.alarmId,
                      dateTime: DateTime.now().add(parameters.time),
                      assetAudioPath: 'assets/sounds/$filename',
                      loopAudio: false,
                      vibrate: false,
                      volumeMax: parameters.maxVolume,
                      fadeDuration: 0,
                      notificationTitle: 'תפילת דרך אוטומטית',
                      notificationBody: 'אומר עכשיו',
                      enableNotificationOnKill: true,
                    );
                    bool success =
                        await Alarm.set(alarmSettings: alarmSettings);
                    if (success) {
                      setState(() {
                        alarmExists = true;
                      });
                    }
                  },
                  child: Text('לקרא עוד מעט'),
                  // style: ButtonStyle(
                  //   backgroundColor: MaterialStateProperty.all(
                  //       AppTheme.lightTheme().primaryColor),
                  //   foregroundColor: MaterialStateProperty.all(Colors.white),
                  // ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
