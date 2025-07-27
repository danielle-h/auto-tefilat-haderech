import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_he.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('he')
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'Tefilat haderech'**
  String get app_title;

  /// No description provided for @home_page_title.
  ///
  /// In en, this message translates to:
  /// **'Tefilat haderech - Ashkenaz'**
  String get home_page_title;

  /// No description provided for @return_today.
  ///
  /// In en, this message translates to:
  /// **'Returning today'**
  String get return_today;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @not_return_today.
  ///
  /// In en, this message translates to:
  /// **'Not returning today'**
  String get not_return_today;

  /// No description provided for @play_now.
  ///
  /// In en, this message translates to:
  /// **'Recite now'**
  String get play_now;

  /// No description provided for @recitation_canceled_successfully.
  ///
  /// In en, this message translates to:
  /// **'Recitation canceled successfully'**
  String get recitation_canceled_successfully;

  /// No description provided for @recitation_canceled_fail.
  ///
  /// In en, this message translates to:
  /// **'Recitation not canceled'**
  String get recitation_canceled_fail;

  /// No description provided for @cancel_recitation.
  ///
  /// In en, this message translates to:
  /// **'Cancel recitation'**
  String get cancel_recitation;

  /// No description provided for @recitation_not_set.
  ///
  /// In en, this message translates to:
  /// **'Recitation not set'**
  String get recitation_not_set;

  /// No description provided for @recite_later.
  ///
  /// In en, this message translates to:
  /// **'Recite later'**
  String get recite_later;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get dark_mode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @choose_language.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get choose_language;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {ver}'**
  String version(Object ver);

  /// No description provided for @about_app.
  ///
  /// In en, this message translates to:
  /// **'About app'**
  String get about_app;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @voice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voice;

  /// No description provided for @which_voice.
  ///
  /// In en, this message translates to:
  /// **'Which voice'**
  String get which_voice;

  /// No description provided for @choose_file.
  ///
  /// In en, this message translates to:
  /// **'Choose file (up to 2 minutes)'**
  String get choose_file;

  /// No description provided for @female_name.
  ///
  /// In en, this message translates to:
  /// **'Danielle'**
  String get female_name;

  /// No description provided for @male_name.
  ///
  /// In en, this message translates to:
  /// **'Samuel'**
  String get male_name;

  /// No description provided for @custom_name.
  ///
  /// In en, this message translates to:
  /// **'My file'**
  String get custom_name;

  /// No description provided for @what_to_read.
  ///
  /// In en, this message translates to:
  /// **'What to recite?'**
  String get what_to_read;

  /// No description provided for @how_much_longer.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get how_much_longer;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'In {num} minutes'**
  String minutes(Object num);

  /// No description provided for @maximum_volume.
  ///
  /// In en, this message translates to:
  /// **'Alarm volume'**
  String get maximum_volume;

  /// No description provided for @set_prayer.
  ///
  /// In en, this message translates to:
  /// **'Set recitation'**
  String get set_prayer;

  /// No description provided for @legalese.
  ///
  /// In en, this message translates to:
  /// **'© Danielle Honigstein 2023'**
  String get legalese;

  /// No description provided for @all_licenses.
  ///
  /// In en, this message translates to:
  /// **'All licenses'**
  String get all_licenses;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get finished;

  /// No description provided for @app_action.
  ///
  /// In en, this message translates to:
  /// **'The app recites the traveler\'s prayer at the time you define.'**
  String get app_action;

  /// No description provided for @app_upload.
  ///
  /// In en, this message translates to:
  /// **'You can also upload your own recitation.'**
  String get app_upload;

  /// No description provided for @app_free.
  ///
  /// In en, this message translates to:
  /// **'The app is free and open source:'**
  String get app_free;

  /// No description provided for @app_code.
  ///
  /// In en, this message translates to:
  /// **'View code'**
  String get app_code;

  /// No description provided for @app_website.
  ///
  /// In en, this message translates to:
  /// **'Check out more apps, games and info on my site:'**
  String get app_website;

  /// No description provided for @my_website.
  ///
  /// In en, this message translates to:
  /// **'danielle-honig.com'**
  String get my_website;

  /// No description provided for @app_coffee.
  ///
  /// In en, this message translates to:
  /// **'If you found it useful you are welcome to buy me a hot chocolate (I don\'t like coffee 😉)'**
  String get app_coffee;

  /// No description provided for @buy_me_a_chocolate.
  ///
  /// In en, this message translates to:
  /// **'Buy me a hot chocolate'**
  String get buy_me_a_chocolate;

  /// No description provided for @thank_you.
  ///
  /// In en, this message translates to:
  /// **'Thank you!'**
  String get thank_you;

  /// No description provided for @notification_title.
  ///
  /// In en, this message translates to:
  /// **'Auto-Tefilat HaDerech'**
  String get notification_title;

  /// No description provided for @notification_body.
  ///
  /// In en, this message translates to:
  /// **'Tap to view'**
  String get notification_body;

  /// No description provided for @no_permission.
  ///
  /// In en, this message translates to:
  /// **'Permission not granted, setting alarm failed'**
  String get no_permission;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'he'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'he':
      return AppLocalizationsHe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
