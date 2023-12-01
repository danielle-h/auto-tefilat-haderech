import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tefilat_haderech/constants.dart';
import 'package:tefilat_haderech/home_page.dart';
import 'package:tefilat_haderech/prayer_type.dart';

class PrayerVersionSelection extends StatefulWidget {
  @override
  _PrayerVersionSelectionState createState() => _PrayerVersionSelectionState();
}

class _PrayerVersionSelectionState extends State<PrayerVersionSelection> {
  PrayerType selectedVersion = PrayerType.ashkenaz;

  void handleVersionSelection(PrayerType? version) {
    if (version == null) {
      return;
    }
    setState(() {
      selectedVersion = version;
    });
  }

  Future<void> saveVersionPreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(Constants.prayerVersion, selectedVersion.index);
    await prefs.setBool(Constants.firstTimeUse, false);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(prayerType: selectedVersion,)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('בחרו נוסח תפילה'),
      ),
      body: Column(
        children: [
          RadioListTile<PrayerType>(
            title: const Text('אשכנז'),
            value: PrayerType.ashkenaz,
            groupValue: selectedVersion,
            onChanged: handleVersionSelection,
          ),
          RadioListTile<PrayerType>(
            title: const Text('ספרד'),
            value: PrayerType.sepharad,
            groupValue: selectedVersion,
            onChanged: handleVersionSelection,
          ),
          ElevatedButton(
            onPressed: saveVersionPreference,
            child: const Text('לשמור ולהמשיך'),
          ),
        ],
      ),
    );
  }
}
