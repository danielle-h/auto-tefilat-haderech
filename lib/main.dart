import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tefilat_haderech/constants.dart';
import 'package:tefilat_haderech/model/app_model_notifier.dart';

import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  runApp(ChangeNotifierProvider(
      create: (context) => AppModelProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModelProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'תפילת הדרך',
      theme: appModel.getTheme(),
      home: Directionality(
          textDirection: TextDirection.rtl,
          child: //FutureBuilder<SharedPreferences>(
              // future: SharedPreferences.getInstance(),
              // builder: (context, snapshot) {
              //   if (snapshot.hasData) {
              //     if (snapshot.data!.containsKey(Constants.firstTimeUse)) {
              //       // Not the first time, go directly to main page
              //       int index = snapshot.data!.getInt(Constants.prayerVersion) ?? 0;
              //return HomePage(prayerType: PrayerType.values[index]);
              HomePage(prayerType: PrayerType.ashkenaz)
          //   } else {
          //     // First time, show prayer version selection
          //     return PrayerVersionSelection();
          //   }
          // } else {
          //   // Waiting for preferences to be initialized
          //   return const Center(child: CircularProgressIndicator());
          // }
          //},
          ),
      // ),
    );
  }
}
