import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tefilat_haderech/prayer_type.dart';
import 'package:tefilat_haderech/styles.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.prayerType});
  final PrayerType prayerType;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final player = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  Future<void> initPlayer() async {
    await player.setAsset("assets/sounds/ashkenaz.mp3");
    print("loop mode: ${player.loopMode}");
    player.playerStateStream.listen((playerState) {
      print("playerstate: ${playerState.processingState}");
      if (playerState.processingState == ProcessingState.completed) {
        setState(() {
          isPlaying = false;
        });
      }
    });
    //player.set
  }

  final String ashkenaz =
      "יְהִי רָצוֹן מִלְפָנֶיךָ יי אֱלֹהֵינוּ וֵאלֹהֵי אֲבוֹתֵינוּ, שֶׁתּוֹלִיכֵנוּ לְשָׁלוֹם וְתַצְעִידֵנוּ לְשָׁלוֹם וְתַדְרִיכֵנוּ לְשָׁלוֹם, וְתִסְמְכֵנוּ לְשָׁלוֹם, וְתַגִּיעֵנוּ לִמְחוֹז חֶפְצֵנוּ לְחַיִּים וּלְשִׂמְחָה וּלְשָׁלוֹם וְתַחְזִירֵנוּ לְשָׁלוֹם וְתַצִּילֵנוּ מִכַּף כָּל אוֹיֵב וְאוֹרֵב וְלִסְטִים וְחַיּוֹת רָעוֹת בַּדֶּרֶךְ, וּמִכָּל מִינֵי פֻּרְעָנֻיּוֹת הַמִּתְרַגְּשׁוֹת לָבוֹא לָעוֹלָם, וְתִתְּנֵנוּ לְחֵן וּלְחֶסֶד וּלְרַחֲמִים בְּעֵינֶיךָ וּבְעֵינֵי כָל רֹאֵינוּ, כִּי אל שׁוֹמֵעַ תְּפִלָּה וְתַחֲנוּן אַתָּה. בָּרוּךְ אַתָּה יי שׁוֹמֵעַ תְּפִלָּה";

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
            child: Container(
              padding: EdgeInsets.all(16),
              child: Text(
                ashkenaz,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                isPlaying ? stop() : readAloud();
              },
              child: isPlaying ? Text("לעצור") : Text('לקרא בקול רם'),
              // style: ButtonStyle(
              //   backgroundColor: MaterialStateProperty.all(
              //       AppTheme.lightTheme().primaryColor),
              //   foregroundColor: MaterialStateProperty.all(Colors.white),
              // ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final alarmSettings = AlarmSettings(
                  id: 42,
                  dateTime: DateTime.now().add(Duration(minutes: 30)),
                  assetAudioPath: 'assets/sounds/ashkenaz.mp3',
                  loopAudio: false,
                  vibrate: false,
                  volumeMax: true,
                  fadeDuration: 0,
                  notificationTitle: 'תפילת דרך אוטומטית',
                  notificationBody: 'אומר עכשיו',
                  enableNotificationOnKill: true,
                );
                await Alarm.set(alarmSettings: alarmSettings);
              },
              child: Text('לקרא עוד מעט'),
              // style: ButtonStyle(
              //   backgroundColor: MaterialStateProperty.all(
              //       AppTheme.lightTheme().primaryColor),
              //   foregroundColor: MaterialStateProperty.all(Colors.white),
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
