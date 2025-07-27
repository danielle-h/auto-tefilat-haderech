import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tefilat_haderech/l10n/app_localizations.dart';
import 'package:tefilat_haderech/model/app_model_notifier.dart';
import 'package:tefilat_haderech/pages/alarm_params_page.dart';
import 'package:tefilat_haderech/model/prayer_parameters.dart';
import 'package:tefilat_haderech/pages/settings_page.dart';

import '../constants.dart';
import 'widgets/animated_tile.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.prayerType});
  final PrayerType prayerType; //For the future, not really used yet

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  //for reciting now
  final player = AudioPlayer();
  bool isPlaying = false; //is it reciting now?

  //alarms
  late final StreamSubscription<AlarmSettings> subscription;
  bool alarmExists = false;

  //model
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
    //init model
    final appModel = Provider.of<AppModelProvider>(context, listen: false);
    appModel.initModel();
    //animations
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn);
    startAnimation();
    //initialize player
    initPlayer();

    super.initState();
    //check alarms on resume
    WidgetsBinding.instance.addObserver(this);
    //alarms
    subscription = Alarm.ringStream.stream.listen((event) {
      //cancel notification and reset home page in one minute
      print("alarm: $event");
      Future.delayed(Duration(minutes: 2), () async {
        print("delayed");
        await checkForAlarms();
      });
    });
  }

  Future<bool> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    print("status: $status");
    if (status.isDenied) {
      final res = await Permission.scheduleExactAlarm.request();
      print("status: ${res.name}");

      return res.isGranted;
    } else {
      return true;
    }
  }

  void startAnimation() {
    animationController.value = 0;
    animationController.forward();
  }

  Future<void> initPlayer() async {
    //this is for reciting now only. in alarm it's handled by the alarm package
    player.playerStateStream.listen((playerState) {
      print("playerstate: ${playerState.processingState}");
      if (playerState.processingState == ProcessingState.completed) {
        setState(() {
          isPlaying = false;
        });
      }
    });
    await checkForAlarms();
  }

  //check for existing alarms
  Future<void> checkForAlarms() async {
    AlarmSettings? previousAlarm = await Alarm.getAlarm(Constants.alarmId);
    print("previous alarm: $previousAlarm");
    if (previousAlarm != null &&
        previousAlarm.dateTime
            .isBefore(DateTime.now().subtract(const Duration(minutes: 1)))) {
      //might be playing now
      print("stopping alarm");
      Alarm.stop(Constants.alarmId); //stop if not stopped already
      previousAlarm = null;
    }
    setState(() {
      alarmExists = previousAlarm != null;
    });
  }

  //recite now
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
            "/data/user/0/com.honeystone.tefilat_haderech/app_flutter/custom.mp3");
        await player.setFilePath(
            "/data/user/0/com.honeystone.tefilat_haderech/app_flutter/custom.mp3");
      }
      setState(() {
        isPlaying = true;
      });
      print("loop mode: ${player.loopMode}");
      player.seek(Duration.zero);

      player.play();
    }
  }

  //stop reciting now. This is not connected to alarms
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
    WidgetsBinding.instance.removeObserver(this);
    subscription.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      print("state: resumed");
      await checkForAlarms();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    AppModelProvider appModel = Provider.of<AppModelProvider>(context);
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
                  "${AppLocalizations.of(context)!.return_today}?",
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
                          if (context.mounted) {
                            final alarmSettings = AlarmSettings(
                              warningNotificationOnKill: true,
                              id: Constants.alarmId,
                              androidFullScreenIntent: false,
                              dateTime: DateTime.now().add(parameters.time),
                              assetAudioPath: parameters.voiceType ==
                                      VoiceType.custom
                                  ? "/data/user/0/com.honeystone.tefilat_haderech/app_flutter/custom.mp3"
                                  : 'assets/sounds/$filename',
                              loopAudio: false,
                              vibrate: false,
                              volumeSettings: VolumeSettings.fixed(
                                volume: parameters.volume,
                                volumeEnforced: false,
                              ),
                              notificationSettings: NotificationSettings(
                                title: AppLocalizations.of(context)!
                                    .notification_title,
                                body: AppLocalizations.of(context)!
                                    .notification_body,
                                stopButton: 'Stop',
                                // icon and iconColor optional
                              ),
                            );
                            //verify permissions
                            bool gotPermission =
                                await checkAndroidScheduleExactAlarmPermission();
                            if (!context.mounted) {
                              return;
                            }
                            if (!gotPermission) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          AppLocalizations.of(context)!
                                              .no_permission)));
                              return;
                            }
                            bool success =
                                await Alarm.set(alarmSettings: alarmSettings);
                            if (success) {
                              setState(() {
                                alarmExists = true;
                              });
                            }
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
