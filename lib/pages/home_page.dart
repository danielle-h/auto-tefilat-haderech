import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tefilat_haderech/pages/alarm_params_page.dart';
import 'package:tefilat_haderech/model/prayer_parameters.dart';
import 'package:tefilat_haderech/backup/prayer_version_selection.dart';
import 'package:tefilat_haderech/pages/settings_page.dart';
import 'package:tefilat_haderech/styles.dart';

import '../constants.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.prayerType});
  final PrayerType prayerType;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final player = AudioPlayer();
  bool isPlaying = false;
  bool alarmExists = false;
  late SharedPreferences prefs;
  PrayerParameters prayerParameters = PrayerParameters();

  @override
  void initState() {
    loadPrefs();
    initPlayer();
    super.initState();
  }

  void loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
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
      "יְהִי רָצוֹן מִלְּפָנֶיךָ יְהֹוָה אֱלֹהֵנוּ וֵאֱלֹהֵי אֲבוֹתֵינוּ, שֶׁתּוֹלִיכֵנוּ לְשָׁלוֹם וְתַצְעִידֵנוּ לְשָׁלוֹם, וְתִסְמְכֵנוּ לְשָׁלוֹם, וְתַנְחֵנוּ אֶל מְחוֹז חֶפְצֵנוּ לְחַיִּים וְלְשִּׂמְחָה ולְשָּׁלוֹם, וְתַחְזִירֵנוּ לְשָׁלוֹם וְתַצִּילֵנוּ מִכַּף כׇּל אוֹיֵב וְאוֹרֵב בַּדֶּרֶךְ וּמִכׇּל מִינֵי פֻּרְעָנֻיּוֹת הַמִּתְרַגְּשׁוֹת לָבוֹא לָעוֹלָם, וְתִשְׁלַח בְּרָכָה בְּמַעֲשֵׂה יָדֵינוּ. וְתִתְנְנוֹ לְחֵן וּלְחֶסֶד וּלְרַחֲמִים בְּעֵינֶיךָ וּבְעֵינֵי כׇּל רוֹאֵינוּ, וְתִשְׁמַע קוֹל תַּחֲנוּנֵינוּ. כִּי אֵל שׁוֹמֵעַ תְּפִלָּה וְתַחֲנוּן אַתָּה. בָּרוּךְ אַתָּה יְהֹוָה שׁוֹמֵעַ תְּפִלָּה.";

  final String ashkenaz_notReturnToday =
      "יְהִי רָצוֹן מִלְּפָנֶיךָ יְהֹוָה אֱלֹהֵנוּ וֵאֱלֹהֵי אֲבוֹתֵינוּ, שֶׁתּוֹלִיכֵנוּ לְשָׁלוֹם וְתַצְעִידֵנוּ לְשָׁלוֹם, וְתִסְמְכֵנוּ לְשָׁלוֹם, וְתַנְחֵנוּ אֶל מְחוֹז חֶפְצֵנוּ לְחַיִּים וְלְשִּׂמְחָה ולְשָּׁלוֹם. וְתַצִּילֵנוּ מִכַּף כׇּל אוֹיֵב וְאוֹרֵב בַּדֶּרֶךְ וּמִכׇּל מִינֵי פֻּרְעָנֻיּוֹת הַמִּתְרַגְּשׁוֹת לָבוֹא לָעוֹלָם, וְתִשְׁלַח בְּרָכָה בְּמַעֲשֵׂה יָדֵינוּ. וְתִתְנְנוֹ לְחֵן וּלְחֶסֶד וּלְרַחֲמִים בְּעֵינֶיךָ וּבְעֵינֵי כׇּל רוֹאֵינוּ, וְתִשְׁמַע קוֹל תַּחֲנוּנֵינוּ. כִּי אֵל שׁוֹמֵעַ תְּפִלָּה וְתַחֲנוּן אַתָּה. בָּרוּךְ אַתָּה יְהֹוָה שׁוֹמֵעַ תְּפִלָּה.";

  void readAloud() async {
    if (!isPlaying) {
      String voice =
          prefs.getString(Constants.voiceType) ?? VoiceType.female.name;
      print(
          "assets/sounds/ashkenaz-$voice-${prayerParameters.returnToday.name}.mp3");
      await player.setAsset(
          "assets/sounds/ashkenaz-$voice-${prayerParameters.returnToday.name}.mp3");
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('תפילת הדרך-אשכנז'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
              icon: Icon(Icons.settings),
            ),
          ],
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
                    prayerParameters.returnToday == ReturnToday.returnToday
                        ? ashkenaz_returnToday
                        : ashkenaz_notReturnToday,
                    style: const TextStyle(
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
                    value:
                        prayerParameters.returnToday == ReturnToday.returnToday,
                    onChanged: (value) async {
                      setState(() {
                        if (value) {
                          prayerParameters.returnToday =
                              ReturnToday.returnToday;
                        } else {
                          prayerParameters.returnToday =
                              ReturnToday.notReturnToday;
                        }
                      });
                    }),
              ],
            ),
            Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // alarmExists
                  //     ? ElevatedButton(
                  //         onPressed: () async {
                  //           bool success = await Alarm.stop(Constants.alarmId);
                  //           if (success) {
                  //             setState(() {
                  //               alarmExists = false;
                  //             });
                  //           }
                  //           if (mounted) {
                  //             if (success) {
                  //               ScaffoldMessenger.of(context).showSnackBar(
                  //                   const SnackBar(
                  //                       content: Text("השמעה בוטלה בהצלחה")));
                  //             } else {
                  //               ScaffoldMessenger.of(context).showSnackBar(
                  //                   const SnackBar(
                  //                       content: Text("ביטול השמעה נכשל")));
                  //             }
                  //           }
                  //         },
                  //         child: Text('לבטל תפילה'),
                  //         // style: ButtonStyle(
                  //         //   backgroundColor: MaterialStateProperty.all(
                  //         //       AppTheme.lightTheme().primaryColor),
                  //         //   foregroundColor: MaterialStateProperty.all(Colors.white),
                  //         // ),
                  //       )
                  //     : const SizedBox.shrink(),
                  ElevatedButton(
                    onPressed: () {
                      isPlaying ? stop() : readAloud();
                    },
                    child: isPlaying ? Text("לעצור") : Text('להשמיע עכשיו'),
                    // style: ButtonStyle(
                    //   backgroundColor: MaterialStateProperty.all(
                    //       AppTheme.lightTheme().primaryColor),
                    //   foregroundColor: MaterialStateProperty.all(Colors.white),
                    // ),
                  ),
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
                                        content: Text("השמעה בוטלה בהצלחה")));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("ביטול השמעה נכשל")));
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.error),
                          child: Text('לבטל תפילה'),
                          // style: ButtonStyle(
                          //   backgroundColor: MaterialStateProperty.all(
                          //       AppTheme.lightTheme().primaryColor),
                          //   foregroundColor: MaterialStateProperty.all(Colors.white),
                          // ),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            PrayerParameters? parameters = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AlarmParametersPage()));
                            if (parameters == null) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("השמעה לא נקבעה")));
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
                          child: Text('להשמיע עוד מעט'),
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
      ),
    );
  }
}
