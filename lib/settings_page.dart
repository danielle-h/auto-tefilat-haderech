import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tefilat_haderech/constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String voice = Constants.femaleName; //TODO read from prefs
  late SharedPreferences prefs;

  @override
  void initState() {
    loadPrefs();
    super.initState();
  }

  void loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      voice = prefs.getString(Constants.voiceType) ?? VoiceType.female.name;
    });
  }

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
                  value: voice == VoiceType.female.name
                      ? const Text(Constants.femaleName)
                      : const Text(Constants.maleName),
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
                      setState(() {
                        voice = newVoice;
                      });
                      prefs.setString(
                          Constants.voiceType,
                          newVoice == Constants.femaleName
                              ? VoiceType.female.name
                              : VoiceType.male.name);
                    }
                  },
                ),
                SettingsTile.switchTile(
                  onToggle: (value) {},
                  enabled: false,
                  initialValue: false,
                  leading: Icon(Icons.format_paint),
                  title: Text('מצב כהה (בקרוב)'),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
