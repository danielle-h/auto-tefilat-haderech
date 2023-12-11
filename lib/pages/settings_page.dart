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

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late AppModelNotifier appModelNotifier =
      Provider.of<AppModelNotifier>(context, listen: false);
//  late SharedPreferences prefs;

  @override
  void initState() {
    //loadPrefs();

    super.initState();
  }

  // void loadPrefs() async {
  //   prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     voice = prefs.getString(Constants.voiceType) ?? VoiceType.female.name;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
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
                  value: Consumer<AppModelNotifier>(
                    builder: (context, appModel, child) {
                      return Text(Util.voiceType2String(appModel.getVoice()));
                    },
                  ),
                  // voice == Constants.femaleName
                  //     ? const Text(Constants.femaleName)
                  //     : const Text(Constants.maleName),
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
                                      // File pickedFile = File.fromUri(
                                      //     Uri.parse(file.identifier!));
                                      File cachedFile = await pickedFile.copy(
                                          "${directory.path}${Platform.pathSeparator}custom.mp3");

                                      print(
                                          "files: ${file.name} ${cachedFile.path}");
                                      if (mounted) {
                                        Navigator.pop(context, cachedFile.path);
                                      }
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
                      appModelNotifier
                          .updateVoice(Util.string2VoiceType(newVoice));
                    }
                  },
                ),
                SettingsTile.switchTile(
                  onToggle: (value) {
                    appModelNotifier.toggleTheme();
                  },
                  //enabled: false,
                  initialValue:
                      appModelNotifier.getTheme() == AppTheme.darkTheme(),

                  leading: Icon(Icons.format_paint),
                  title: Text('מצב כהה'),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
