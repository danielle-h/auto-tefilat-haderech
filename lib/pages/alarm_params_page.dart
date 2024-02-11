import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tefilat_haderech/constants.dart';
import 'package:tefilat_haderech/model/prayer_parameters.dart';
import 'package:tefilat_haderech/pages/widgets/animated_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AlarmParametersPage extends StatefulWidget {
  AlarmParametersPage({super.key});

  @override
  State<AlarmParametersPage> createState() => _AlarmParametersPageState();
}

class _AlarmParametersPageState extends State<AlarmParametersPage>
    with TickerProviderStateMixin {
  int numMinutes = 5;
  static const double spaceAbove = 20;
  static const double spaceBetween = 10;

  PrayerType prayerType = PrayerType.ashkenaz;
  VoiceType voiceType = VoiceType.female;
  ReturnToday returnToday = ReturnToday.returnToday;
  bool maxVolume = true;
  bool vibrate = false;

  //animation
  late AnimationController animationController;
  late Animation<double> animation;
  List<double> slide = [10, 30, 50, 90];

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn);
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

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
                  AnimatedTile(
                    animation: animation,
                    slide: slide[0],
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: spaceAbove,
                        ),
                        const Text("עוד כמה זמן?"),
                        const SizedBox(
                          height: spaceBetween,
                        ),
                        //when to set the alarm
                        SizedBox(
                          height: 60,
                          child: CupertinoPicker(
                              onSelectedItemChanged: (newNum) {
                                numMinutes = (newNum + 1) * 5;
                              },
                              itemExtent: 30,
                              children: List.generate(24,
                                  (index) => Text("${(index + 1) * 5} דקות"))),
                        ),
                      ],
                    ),
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
                  AnimatedTile(
                    animation: animation,
                    slide: slide[1],
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: spaceAbove,
                        ),
                        const Text("איזה קול?"),
                        const SizedBox(
                          height: spaceBetween,
                        ),
                        //which voice
                        DropdownMenu(
                            onSelected: (value) {
                              voiceType = value ?? voiceType;
                            },
                            initialSelection: voiceType,
                            dropdownMenuEntries: [
                              DropdownMenuEntry<VoiceType>(
                                  value: VoiceType.female,
                                  label: AppLocalizations.of(context)!.female_name),
                              DropdownMenuEntry<VoiceType>(
                                  value: VoiceType.male,
                                  label: AppLocalizations.of(context)!.male_name),
                              DropdownMenuEntry<VoiceType>(
                                  value: VoiceType.custom,
                                  label: AppLocalizations.of(context)!.custom_name)
                            ]),
                      ],
                    ),
                  ),
                  //return today?
                  AnimatedTile(
                    animation: animation,
                    slide: slide[2],
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: spaceAbove,
                        ),
                        const Text("חוזרים היום?"),
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
                      ],
                    ),
                  ),
                  //maximum volume?
                  AnimatedTile(
                    animation: animation,
                    slide: slide[3],
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                      ],
                    ),
                  ),
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
