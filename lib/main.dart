import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tefilat_haderech/constants.dart';
import 'package:tefilat_haderech/l10n/app_localizations.dart';
import 'package:tefilat_haderech/model/app_model_notifier.dart';
import 'package:tefilat_haderech/services/audio_service_singleton.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  // Enter fullscreen immersive mode
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => AppModelProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  AudioServiceSingleton get audioService =>
      AudioServiceSingleton.instance; // Access the singleton instance

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModelProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) {
        return AppLocalizations.of(context)!.app_title;
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: appModel.getTheme(),
      locale: Locale(appModel.getLocale()),
      home:
          HomePage(prayerType: PrayerType.ashkenaz, audioService: audioService),
      // ),
    );
  }
}
