// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'Tefilat haderech';

  @override
  String get home_page_title => 'Tefilat haderech - Ashkenaz';

  @override
  String get return_today => 'Returning today';

  @override
  String get stop => 'Stop';

  @override
  String get not_return_today => 'Not returning today';

  @override
  String get play_now => 'Recite now';

  @override
  String get recitation_canceled_successfully =>
      'Recitation canceled successfully';

  @override
  String get recitation_canceled_fail => 'Recitation not canceled';

  @override
  String get cancel_recitation => 'Cancel recitation';

  @override
  String get recitation_not_set => 'Recitation not set';

  @override
  String get recite_later => 'Recite later';

  @override
  String get dark_mode => 'Dark mode';

  @override
  String get language => 'Language';

  @override
  String get choose_language => 'Choose language';

  @override
  String version(Object ver) {
    return 'Version $ver';
  }

  @override
  String get about_app => 'About app';

  @override
  String get settings => 'Settings';

  @override
  String get voice => 'Voice';

  @override
  String get which_voice => 'Which voice';

  @override
  String get choose_file => 'Choose file (up to 2 minutes)';

  @override
  String get female_name => 'Danielle';

  @override
  String get male_name => 'Samuel';

  @override
  String get custom_name => 'My file';

  @override
  String get what_to_read => 'What to recite?';

  @override
  String get how_much_longer => 'When';

  @override
  String minutes(Object num) {
    return 'In $num minutes';
  }

  @override
  String get maximum_volume => 'Alarm volume';

  @override
  String get set_prayer => 'Set recitation';

  @override
  String get legalese => '© Danielle Honigstein 2023';

  @override
  String get all_licenses => 'All licenses';

  @override
  String get finished => 'Done';

  @override
  String get app_action =>
      'The app recites the traveler\'s prayer at the time you define.';

  @override
  String get app_upload => 'You can also upload your own recitation.';

  @override
  String get app_free => 'The app is free and open source:';

  @override
  String get app_code => 'View code';

  @override
  String get app_website => 'Check out more apps, games and info on my site:';

  @override
  String get my_website => 'danielle-honig.com';

  @override
  String get app_coffee =>
      'If you found it useful you are welcome to buy me a hot chocolate';

  @override
  String get buy_me_a_chocolate => 'Buy me a hot chocolate';

  @override
  String get thank_you => 'Thank you!';

  @override
  String get notification_title => 'Auto-Tefilat HaDerech';

  @override
  String get notification_body => 'Tap to view';

  @override
  String get no_permission => 'Permission not granted, setting alarm failed';

  @override
  String get rate_app => 'Rate and review in the app store';

  @override
  String get app_contact => 'Questions? Problems? Suggestions?';

  @override
  String get contact_me => 'Contact me';
}
