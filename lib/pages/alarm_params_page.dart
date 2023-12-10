import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tefilat_haderech/constants.dart';
import 'package:tefilat_haderech/model/prayer_parameters.dart';

class AlarmParametersPage extends StatefulWidget {
  AlarmParametersPage({super.key});

  @override
  State<AlarmParametersPage> createState() => _AlarmParametersPageState();
}

class _AlarmParametersPageState extends State<AlarmParametersPage> {
  int numMinutes = 5;
  static const double spaceAbove = 20;
  static const double spaceBetween = 10;

  PrayerType prayerType = PrayerType.ashkenaz;
  VoiceType voiceType = VoiceType.female;
  ReturnToday returnToday = ReturnToday.returnToday;
  bool maxVolume = true;
  bool vibrate = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("מה להקריא?"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.titleLarge!,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: spaceAbove,
                  ),
                  Text("עוד כמה זמן?"),
                  const SizedBox(
                    height: spaceBetween,
                  ),
                  //when to set the alarm
                  SizedBox(
                    height: 60,
                    child: CupertinoPicker(
                        onSelectedItemChanged: (newNum) {
                          numMinutes = newNum;
                        },
                        itemExtent: 30,
                        children: List.generate(
                            24, (index) => Text("${(index + 1) * 5} דקות"))),
                  ),
                  // const SizedBox(
                  //   height: spaceAbove,
                  // ),
                  // Text("נוסח תפילה?"),
                  // const SizedBox(
                  //   height: spaceBetween,
                  // ),
                  // DropdownMenu(
                  //     onSelected: (value) {
                  //       prayerType = value ?? prayerType;
                  //     },
                  //     initialSelection: prayerType,
                  //     dropdownMenuEntries: const [
                  //       DropdownMenuEntry<PrayerType>(
                  //           value: PrayerType.ashkenaz, label: "אשכנז"),
                  //       DropdownMenuEntry<PrayerType>(
                  //           value: PrayerType.sepharad, label: "ספרד")
                  //     ]),
                  const SizedBox(
                    height: spaceAbove,
                  ),
                  Text("איזה קול?"),
                  const SizedBox(
                    height: spaceBetween,
                  ),
                  //which voice
                  DropdownMenu(
                      onSelected: (value) {
                        voiceType = value ?? voiceType;
                      },
                      initialSelection: voiceType,
                      dropdownMenuEntries: const [
                        DropdownMenuEntry<VoiceType>(
                            value: VoiceType.female,
                            label: Constants.femaleName),
                        DropdownMenuEntry<VoiceType>(
                            value: VoiceType.male, label: Constants.maleName)
                      ]),
                  //return today?
                  const SizedBox(
                    height: spaceAbove,
                  ),
                  Text("חוזרים היום?"),
                  const SizedBox(
                    height: spaceBetween,
                  ),
                  DropdownMenu(
                      onSelected: (value) {
                        returnToday = value ?? returnToday;
                      },
                      initialSelection: returnToday,
                      dropdownMenuEntries: const [
                        DropdownMenuEntry<ReturnToday>(
                            value: ReturnToday.returnToday,
                            label: "חוזרים היום"),
                        DropdownMenuEntry<ReturnToday>(
                            value: ReturnToday.notReturnToday,
                            label: "לא חוזרים היום")
                      ]),
                  const SizedBox(
                    height: spaceAbove,
                  ),
                  const Text("ווליום מקסימלי?"),
                  const SizedBox(
                    height: spaceBetween,
                  ),

                  Switch(
                      value: maxVolume,
                      onChanged: (value) {
                        setState(() {
                          maxVolume = value;
                        });
                      }),
                  const SizedBox(
                    height: spaceAbove,
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        PrayerParameters parameters = PrayerParameters();
                        parameters.prayerType = prayerType;
                        parameters.returnToday = returnToday;
                        parameters.time = Duration(minutes: numMinutes);
                        parameters.voiceType = voiceType;
                        parameters.maxVolume = maxVolume;
                        Navigator.pop(context, parameters);
                        //parameters.prayerType =
                      },
                      child: const Text('לקבוע תפילה'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
