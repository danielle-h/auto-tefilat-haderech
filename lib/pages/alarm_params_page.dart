import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tefilat_haderech/constants.dart';
import 'package:tefilat_haderech/l10n/app_localizations.dart';
import 'package:tefilat_haderech/model/prayer_parameters.dart';
import 'package:tefilat_haderech/pages/widgets/animated_tile.dart';

class AlarmParametersPage extends StatefulWidget {
  AlarmParametersPage({super.key, required this.parameters});
  PrayerParameters parameters;

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
  double volume = 1.0;
  bool vibrate = false;

  //animation
  late AnimationController animationController;
  late Animation<double> animation;
  List<double> slide = [10, 30, 50, 90];

  //UI
  final int pickerStep = 5;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn);
    animationController.forward();
    setState(() {
      numMinutes = widget.parameters.time.inMinutes;
      prayerType = widget.parameters.prayerType;
      voiceType = widget.parameters.voiceType;
      returnToday = widget.parameters.returnToday;
      volume = widget.parameters.volume;
    });
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
        child: Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.what_to_read),
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
                      Text("${AppLocalizations.of(context)!.how_much_longer}?"),
                      const SizedBox(
                        height: spaceBetween,
                      ),
                      //when to set the alarm
                      SizedBox(
                        height: 60,
                        child: CupertinoPicker(
                            onSelectedItemChanged: (newNum) {
                              numMinutes = (newNum + 1) * pickerStep;
                            },
                            itemExtent: 30,
                            scrollController: FixedExtentScrollController(
                                initialItem: (numMinutes ~/ pickerStep) - 1),
                            children: List.generate(
                                24,
                                (index) => Text(AppLocalizations.of(context)!
                                    .minutes((index + 1) * pickerStep)))),
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
                      Text("${AppLocalizations.of(context)!.which_voice}?"),
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
                                label:
                                    AppLocalizations.of(context)!.female_name),
                            DropdownMenuEntry<VoiceType>(
                                value: VoiceType.male,
                                label: AppLocalizations.of(context)!.male_name),
                            DropdownMenuEntry<VoiceType>(
                                value: VoiceType.custom,
                                label:
                                    AppLocalizations.of(context)!.custom_name)
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
                      Text("${AppLocalizations.of(context)!.return_today}?"),
                      const SizedBox(
                        height: spaceBetween,
                      ),
                      DropdownMenu(
                          onSelected: (value) {
                            returnToday = value ?? returnToday;
                          },
                          initialSelection: returnToday,
                          dropdownMenuEntries: [
                            DropdownMenuEntry<ReturnToday>(
                                value: ReturnToday.returnToday,
                                label:
                                    AppLocalizations.of(context)!.return_today),
                            DropdownMenuEntry<ReturnToday>(
                                value: ReturnToday.notReturnToday,
                                label: AppLocalizations.of(context)!
                                    .not_return_today)
                          ]),
                    ],
                  ),
                ),
                AnimatedTile(
                  animation: animation,
                  slide: slide[3],
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: spaceAbove,
                      ),
                      Text("${AppLocalizations.of(context)!.maximum_volume}?"),
                      const SizedBox(
                        height: spaceBetween,
                      ),
                      Slider(
                          value: volume,
                          onChanged: (newVolume) {
                            setState(() {
                              volume = newVolume;
                            });
                          },
                          min: 0,
                          max: 1.0)
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
                      //print("numMinutes: $numMinutes");
                      PrayerParameters parameters = PrayerParameters();
                      parameters.prayerType = prayerType;
                      parameters.returnToday = returnToday;
                      parameters.time = Duration(minutes: numMinutes);
                      parameters.voiceType = voiceType;
                      parameters.volume = volume;
                      //print(parameters.time);
                      Navigator.pop(context, parameters);
                      //parameters.prayerType =
                    },
                    child: Text(AppLocalizations.of(context)!.set_prayer),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
