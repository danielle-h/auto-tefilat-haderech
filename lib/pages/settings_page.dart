import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:tefilat_haderech/constants.dart';
import 'package:tefilat_haderech/model/app_model_notifier.dart';
import 'package:tefilat_haderech/styles.dart';
import 'package:uri_to_file/uri_to_file.dart';

import 'widgets/app_dialog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String appVersion = "";

  @override
  void initState() {
    getPackageInfo();
    super.initState();
  }

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

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
                //which voice?
                SettingsTile(
                  title: const Text("קול"),
                  value: Text(appModel.getVoice() == VoiceType.custom
                      ? appModel.getFilename()
                      : Util.voiceType2String(appModel.getVoice())),
                  leading: const Icon(Icons.record_voice_over),
                  onPressed: (context) async {
                    //open dialog to choose voice
                    String? newVoice = await showDialog<String>(
                        context: context,
                        builder: (context) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: SimpleDialog(
                              title: Text("איזה קול?"),
                              children: [
                                //female
                                SimpleDialogOption(
                                  onPressed: () {
                                    print("chose female");
                                    Navigator.pop(
                                        context, Constants.femaleName);
                                  },
                                  child: const Text(Constants.femaleName),
                                ),
                                //male
                                SimpleDialogOption(
                                  onPressed: () {
                                    Navigator.pop(context, Constants.maleName);
                                  },
                                  child: const Text(Constants.maleName),
                                ),
                                //custom filename if exists
                                appModel.getFilename().isEmpty
                                    ? const SizedBox.shrink()
                                    : SimpleDialogOption(
                                        onPressed: () {
                                          Navigator.pop(
                                              context, appModel.getFilename());
                                        },
                                        child: Text(appModel.getFilename()),
                                      ),
                                //Choose new file and copy to app directory
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
                                      if (mounted) {
                                        Navigator.pop(context, file.name);
                                      }
                                      return;
                                    }
                                    //if canceled return null
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
                    //update voicetype
                    if (newVoice != null) {
                      VoiceType voiceType = Util.string2VoiceType(newVoice);
                      print("settings: $voiceType");
                      appModel.updateVoice(voiceType);
                    }
                  },
                ),
                //dark or light mode
                SettingsTile.switchTile(
                  onToggle: (value) {
                    appModel.toggleTheme();
                  },
                  initialValue: appModel.getTheme() == AppTheme.darkTheme(),
                  leading: const Icon(Icons.format_paint),
                  title: const Text('מצב כהה'),
                ),
                //language
                SettingsTile(
                  title: const Text("שפה"),
                  value: Text(appLanguages[appModel.getLocale()]!),
                  leading: const Icon(Icons.language),
                  onPressed: (context) async {
                    //open dialog to choose voice
                    AppLocale? newLocale = await showDialog<AppLocale>(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            title: Text("בחירת שפה"),
                            children: [
                              //English
                              SimpleDialogOption(
                                onPressed: () {
                                  print("chose english");
                                  Navigator.pop(context, AppLocale.en);
                                },
                                child: const Text("English"),
                              ),
                              //Hebrew
                              SimpleDialogOption(
                                onPressed: () {
                                  Navigator.pop(context, AppLocale.he);
                                },
                                child: const Text("עברית"),
                              ),
                            ],
                          );
                        });
                    print("settings: $newLocale");
                    //update voicetype
                    if (newLocale != null) {
                      appModel.updateLocale(newLocale);
                    }
                  },
                ),
                //about app
                SettingsTile(
                    leading: const Icon(Icons.question_mark),
                    onPressed: (context) {
                      //not using aboutdialog because of directionality
                      showDialog(
                          context: context,
                          builder: ((context) {
                            String appName = "תפילת דרך אוטומטית";
                            String copyright =
                                "כל הזכויות שמורות לדניאל הוניגשטיין 2023";
                            return AppDialog(
                                appName: appName,
                                version: appVersion,
                                copyright: copyright);
                          }));
                    },
                    value: Text("גרסה $appVersion"),
                    title: const Text("על האפליקציה"))
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
