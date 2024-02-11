import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:tefilat_haderech/model/app_model_notifier.dart';
import 'package:tefilat_haderech/pages/alarm_params_page.dart';
import 'package:tefilat_haderech/model/prayer_parameters.dart';
import 'package:tefilat_haderech/pages/settings_page.dart';
import 'package:tefilat_haderech/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants.dart';
import 'widgets/animated_tile.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.prayerType});
  final PrayerType prayerType;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final player = AudioPlayer();
  bool isPlaying = false;
  bool alarmExists = false;
  PrayerParameters prayerParameters = PrayerParameters();

  //animation
  late AnimationController animationController;
  late Animation<double> animation;
  List<double> slide = [10, 30, 50, 90];

  //texts
  final String ashkenaz_returnToday =
      "יְהִי רָצוֹן מִלְּפָנֶיךָ ה' אֱלֹהֵנוּ וֵאֱלֹהֵי אֲבוֹתֵינוּ, שֶׁתּוֹלִיכֵנוּ לְשָׁלוֹם וְתַצְעִידֵנוּ לְשָׁלוֹם, וְתִסְמְכֵנוּ לְשָׁלוֹם, וְתַנְחֵנוּ אֶל מְחוֹז חֶפְצֵנוּ לְחַיִּים וְלְשִּׂמְחָה ולְשָּׁלוֹם, וְתַחְזִירֵנוּ לְשָׁלוֹם וְתַצִּילֵנוּ מִכַּף כׇּל אוֹיֵב וְאוֹרֵב בַּדֶּרֶךְ וּמִכׇּל מִינֵי פֻּרְעָנֻיּוֹת הַמִּתְרַגְּשׁוֹת לָבוֹא לָעוֹלָם, וְתִשְׁלַח בְּרָכָה בְּמַעֲשֵׂה יָדֵינוּ. וְתִתְנְנוֹ לְחֵן וּלְחֶסֶד וּלְרַחֲמִים בְּעֵינֶיךָ וּבְעֵינֵי כׇּל רוֹאֵינוּ, וְתִשְׁמַע קוֹל תַּחֲנוּנֵינוּ. כִּי אֵל שׁוֹמֵעַ תְּפִלָּה וְתַחֲנוּן אַתָּה. בָּרוּךְ אַתָּה ה' שׁוֹמֵעַ תְּפִלָּה.";

  final String ashkenaz_notReturnToday =
      "יְהִי רָצוֹן מִלְּפָנֶיךָ ה' אֱלֹהֵנוּ וֵאֱלֹהֵי אֲבוֹתֵינוּ, שֶׁתּוֹלִיכֵנוּ לְשָׁלוֹם וְתַצְעִידֵנוּ לְשָׁלוֹם, וְתִסְמְכֵנוּ לְשָׁלוֹם, וְתַנְחֵנוּ אֶל מְחוֹז חֶפְצֵנוּ לְחַיִּים וְלְשִּׂמְחָה ולְשָּׁלוֹם. וְתַצִּילֵנוּ מִכַּף כׇּל אוֹיֵב וְאוֹרֵב בַּדֶּרֶךְ וּמִכׇּל מִינֵי פֻּרְעָנֻיּוֹת הַמִּתְרַגְּשׁוֹת לָבוֹא לָעוֹלָם, וְתִשְׁלַח בְּרָכָה בְּמַעֲשֵׂה יָדֵינוּ. וְתִתְנְנוֹ לְחֵן וּלְחֶסֶד וּלְרַחֲמִים בְּעֵינֶיךָ וּבְעֵינֵי כׇּל רוֹאֵינוּ, וְתִשְׁמַע קוֹל תַּחֲנוּנֵינוּ. כִּי אֵל שׁוֹמֵעַ תְּפִלָּה וְתַחֲנוּן אַתָּה. בָּרוּךְ אַתָּה ה' שׁוֹמֵעַ תְּפִלָּה.";

  @override
  void initState() {
    final appModel = Provider.of<AppModelProvider>(context, listen: false);
    appModel.initModel();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn);

    startAnimation();
    initPlayer();
    super.initState();
  }

  void startAnimation() {
    animationController.value = 0;
    animationController.forward();
  }

  Future<void> initPlayer() async {
    //await player.setAsset("assets/sounds/ashkenaz-female-notReturnToday.mp3");
    //print("loop mode: ${player.loopMode}");
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

  void readAloud(VoiceType voiceType) async {
    if (!isPlaying) {
      print("home voice: $voiceType");
      String voice = voiceType.name;

      if (voiceType != VoiceType.custom) {
        print(
            "assets/sounds/ashkenaz-$voice-${prayerParameters.returnToday.name}.mp3");
        await player.setAsset(
            "assets/sounds/ashkenaz-$voice-${prayerParameters.returnToday.name}.mp3");
      } else {
        print(
            "/data/user/0/com.example.tefilat_haderech/app_flutter/custom.mp3");
        await player.setFilePath(
            "/data/user/0/com.example.tefilat_haderech/app_flutter/custom.mp3");
      }
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
    animationController.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppModelProvider appModel = Provider.of<AppModelProvider>(context);
    print("rebuilding home");
    print(appModel.getLocale());
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home_page_title),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
              startAnimation();
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // AnimatedBuilder(
          //     animation: animation,
          //     builder: (context, child) {
          //       return Transform(
          //         transform: Matrix4.translationValues(
          //             0, (1.0 - animation.value) * slide[0], 0),
          //         child: Container(
          //           padding: EdgeInsets.all(16),
          //           child: Text(
          //             "תפילת הדרך",
          //             style: Theme.of(context).textTheme.titleLarge,
          //           ),
          //         ),
          //       );
          //     }),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: AnimatedTile(
                  animation: animation,
                  slide: slide[1],
                  child: Directionality(
                    textDirection: TextDirection.rtl,
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
            ),
          ),
          // ),
          AnimatedTile(
            animation: animation,
            slide: slide[2],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  AppLocalizations.of(context)!.return_today,
                  style: const TextStyle(
                    fontSize: 24,
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
          ),
          Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print("onpressed: ${appModel.getVoice()}");
                    isPlaying ? stop() : readAloud(appModel.getVoice());
                  },
                  style: isPlaying
                      ? ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onSecondary)
                      : ElevatedButton.styleFrom(),
                  child: isPlaying
                      ? Text(AppLocalizations.of(context)!.stop)
                      : Text(AppLocalizations.of(context)!.play_now),
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
                                  SnackBar(
                                      content: Text(AppLocalizations.of(
                                              context)!
                                          .recitation_canceled_successfully)));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          AppLocalizations.of(context)!
                                              .recitation_canceled_fail)));
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            foregroundColor:
                                Theme.of(context).colorScheme.onError),
                        child: Text(
                            AppLocalizations.of(context)!.cancel_recitation),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          PrayerParameters? parameters = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AlarmParametersPage()));
                          startAnimation();
                          if (parameters == null) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          AppLocalizations.of(context)!
                                              .recitation_not_set)));
                            }
                            return;
                          }
                          print(parameters);
                          String filename =
                              "${parameters.prayerType.name}-${parameters.voiceType.name}-${parameters.returnToday.name}.mp3";
                          final alarmSettings = AlarmSettings(
                            id: Constants.alarmId,
                            dateTime: DateTime.now().add(parameters.time),
                            assetAudioPath: parameters.voiceType ==
                                    VoiceType.custom
                                ? "/data/user/0/com.example.tefilat_haderech/app_flutter/custom.mp3"
                                : 'assets/sounds/$filename',
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
                        child: Text(AppLocalizations.of(context)!.recite_later),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
