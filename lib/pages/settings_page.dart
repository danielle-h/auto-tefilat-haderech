import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:tefilat_haderech/constants.dart';
import 'package:tefilat_haderech/model/app_model_notifier.dart';
import 'package:tefilat_haderech/styles.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'package:url_launcher/link.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // late AppModelProvider appModelNotifier =
  //     Provider.of<AppModelProvider>(context, listen: false);
  // String chosenVoice = "";
  //  late SharedPreferences prefs;

  // @override
  // void initState() {
  //   //loadPrefs();
  //   // chosenVoice = Util.voiceType2String(appModelNotifier.getVoice());
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    AppModelProvider appModel = Provider.of<AppModelProvider>(context);
    print("settings appmodel voice: ${appModel.getVoice()}");
    return SafeArea(
        child: Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("הגדרות"),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              tiles: <SettingsTile>[
                SettingsTile(
                  title: Text("קול"),
                  value: Text(Util.voiceType2String(appModel.getVoice())),
                  // value: Text(Util.voiceType2String(
                  //     Provider.of<AppModelNotifier>(context).getVoice())),
                  // value: Consumer<AppModelNotifier>(
                  //   builder: (context, appModel, child) {
                  //     print("in settings ${appModel.getVoice()}");
                  //     if (appModel.getVoice() != VoiceType.custom) {
                  //       return Text(Util.voiceType2String(appModel.getVoice()));
                  //     }
                  //     return Text(appModel.getFilename());
                  //   },
                  // ),
                  // value:
                  //     Text(Util.voiceType2String(appModelNotifier.getVoice())),
                  leading: Icon(Icons.record_voice_over),
                  onPressed: (context) async {
                    String? newVoice = await showDialog<String>(
                        context: context,
                        builder: (context) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: SimpleDialog(
                              title: Text("איזה קול?"),
                              children: [
                                SimpleDialogOption(
                                  onPressed: () {
                                    print("chose female");
                                    Navigator.pop(
                                        context, Constants.femaleName);
                                  },
                                  child: const Text(Constants.femaleName),
                                ),
                                SimpleDialogOption(
                                  onPressed: () {
                                    Navigator.pop(context, Constants.maleName);
                                  },
                                  child: const Text(Constants.maleName),
                                ),
                                appModel.getFilename().isEmpty
                                    ? const SizedBox.shrink()
                                    : SimpleDialogOption(
                                        onPressed: () {
                                          Navigator.pop(
                                              context, appModel.getFilename());
                                        },
                                        child: Text(appModel.getFilename()),
                                      ),
                                SimpleDialogOption(
                                  onPressed: () async {
                                    FilePickerResult? result = await FilePicker
                                        .platform
                                        .pickFiles(type: FileType.audio);
                                    if (result != null) {
                                      PlatformFile file = result.files.first;
                                      final directory =
                                          await getApplicationDocumentsDirectory();
                                      print("uri: ${file.identifier}");
                                      File pickedFile =
                                          await toFile(file.identifier!);
                                      print("picked file: ${pickedFile.path}");
                                      File cachedFile = await pickedFile.copy(
                                          "${directory.path}${Platform.pathSeparator}custom.mp3");

                                      print(
                                          "files: ${file.name} ${cachedFile.path}");
                                      appModel.updateFilename(file.name);
                                    }
                                    if (mounted) {
                                      Navigator.pop(context, null);
                                    }
                                  },
                                  child: const Text("לבחור קובץ..."),
                                )
                              ],
                            ),
                          );
                        });
                    print("settings: $newVoice");
                    if (newVoice != null) {
                      VoiceType voiceType = Util.string2VoiceType(newVoice);
                      print("settings: $voiceType");
                      appModel.updateVoice(voiceType);
                      if (voiceType == VoiceType.custom) {
                        appModel.updateFilename(newVoice);
                      }
                    }
                  },
                ),
                SettingsTile.switchTile(
                  onToggle: (value) {
                    appModel.toggleTheme();
                  },
                  //enabled: false,
                  initialValue: appModel.getTheme() == AppTheme.darkTheme(),

                  leading: Icon(Icons.format_paint),
                  title: Text('מצב כהה'),
                ),
                SettingsTile.navigation(
                    leading: const Icon(Icons.question_mark),
                    onPressed: (context) {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            String appName = "תפילת דרך אוטומטית";
                            String version = "1.0.0"; //TODO package_info_plus
                            String copyright =
                                "כל הזכויות שמורות לדניאל הוניגשטיין 2023";
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: AlertDialog(
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        showLicensePage(context: context);
                                      },
                                      child: Text("כל הרשיונות")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("סיימתי")),
                                ],
                                title: Text(
                                  "$appName $version",
                                  textAlign: TextAlign.center,
                                ),
                                content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(copyright),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                          "האפליקציה משמיעה את תפילת הדרך בזמן שאתם קובעים."),
                                      const Text(
                                          "אתם יכולים גם להעלות הקלטה שלכם."),
                                      const Text(
                                          "האפליקציה חינמית והקוד שלה פתוח:"),
                                      Link(
                                          uri: Uri.parse(
                                              "https://github.com/danielle-h/auto-tefilat-haderech"),
                                          target: LinkTarget.defaultTarget,
                                          builder: (BuildContext ctx,
                                              FollowLink? openLink) {
                                            return TextButton(
                                                onPressed: openLink,
                                                child: Text("צפו בקוד"));
                                          }),
                                      const Text(
                                          "יש עוד דברים מעניינים באתר שלי"),
                                      Link(
                                          uri: Uri.parse(
                                              "https://danielle-honig.com/"),
                                          target: LinkTarget.defaultTarget,
                                          builder: (BuildContext ctx,
                                              FollowLink? openLink) {
                                            return TextButton(
                                                onPressed: openLink,
                                                child: Text("אתר שלי"));
                                          }),
                                      const Text(
                                          "אם אהבתם מוזמנים לקנות לי שוקו: (אני לא אוהבת קפה ;) )"),
                                      Link(
                                          uri: Uri.parse(
                                              "https://www.buymeacoffee.com/369wkrttu6"),
                                          target: LinkTarget.defaultTarget,
                                          builder: (BuildContext ctx,
                                              FollowLink? openLink) {
                                            return TextButton(
                                                onPressed: openLink,
                                                child: Text("קנו לי שוקו"));
                                          }),
                                      Text(
                                        "תודה רבה!",
                                        textAlign: TextAlign.center,
                                      ),
                                    ]),
                              ),
                            );
                          }));
                    },
                    value: Text("גרסה 1.0.0"),
                    title: const Text("על האפליקציה"))
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
