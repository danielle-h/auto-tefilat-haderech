import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tefilat_haderech/constants.dart';
import 'package:tefilat_haderech/l10n/app_localizations.dart';
import 'package:tefilat_haderech/model/app_model_notifier.dart';
import 'pages/home_page.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://ec27c468ef694ca4ad3e717e1da4fc51@o4509661316448256.ingest.de.sentry.io/4509740898713680';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 0.5;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 0.5;
    },
    appRunner: () => runApp(SentryWidget(
        child: ChangeNotifierProvider(
            create: (context) => AppModelProvider(), child: const MyApp()))),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: HomePage(prayerType: PrayerType.ashkenaz),
      // ),
    );
  }
}
