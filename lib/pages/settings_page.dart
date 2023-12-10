import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:tefilat_haderech/constants.dart';
import 'package:tefilat_haderech/model/app_model_notifier.dart';
import 'package:tefilat_haderech/styles.dart';

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
                      return Text(appModel.getVoice() == VoiceType.female
                          ? Constants.femaleName
                          : Constants.maleName);
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
                                )
                              ],
                            ),
                          );
                        });
                    print("settings: $newVoice");
                    if (newVoice != null) {
                      appModelNotifier.updateVoice(
                          newVoice == Constants.femaleName
                              ? VoiceType.female
                              : VoiceType.male);
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
