import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tefilat_haderech/audio_service.dart';
import 'package:tefilat_haderech/constants.dart';
import 'package:tefilat_haderech/l10n/app_localizations.dart';
import 'package:tefilat_haderech/model/app_model_notifier.dart';
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
    final theme = context
        .select<AppModelProvider, ThemeData>((model) => model.getTheme());
    final locale =
        context.select<AppModelProvider, String>((model) => model.getLocale());
    print("HOME rebuild from main:");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) {
        return AppLocalizations.of(context)!.app_title;
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: theme,
      locale: Locale(locale),
      home: HomePage(
        prayerType: PrayerType.ashkenaz,
        audioService: audioService,
      ),
      // ),
    );
  }
}
