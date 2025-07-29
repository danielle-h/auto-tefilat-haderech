// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get app_title => 'תפילת הדרך';

  @override
  String get home_page_title => 'תפילת הדרך-אשכנז';

  @override
  String get return_today => 'חוזרים היום';

  @override
  String get stop => 'לעצור';

  @override
  String get not_return_today => 'לא חוזרים היום';

  @override
  String get play_now => 'להשמיע עכשיו';

  @override
  String get recitation_canceled_successfully => 'השמעה בוטלה בהצלחה';

  @override
  String get recitation_canceled_fail => 'ביטול השמעה נכשל';

  @override
  String get cancel_recitation => 'לבטל תפילה';

  @override
  String get recitation_not_set => 'השמעה לא נקבעה';

  @override
  String get recite_later => 'להשמיע עוד מעט';

  @override
  String get dark_mode => 'מצב כהה';

  @override
  String get language => 'שפה';

  @override
  String get choose_language => 'בחירת שפה';

  @override
  String version(Object ver) {
    return 'גרסה $ver';
  }

  @override
  String get about_app => 'על האפליקציה';

  @override
  String get settings => 'הגדרות';

  @override
  String get voice => 'קול';

  @override
  String get which_voice => 'איזה קול';

  @override
  String get choose_file => 'לבחור קובץ (עד 1.5 דקות)';

  @override
  String get female_name => 'תהילה';

  @override
  String get male_name => 'שמואל';

  @override
  String get custom_name => 'קובץ שלי';

  @override
  String get what_to_read => 'מה להקריא';

  @override
  String get how_much_longer => 'עוד כמה זמן';

  @override
  String minutes(Object num) {
    return '$num דקות';
  }

  @override
  String get maximum_volume => 'ווליום';

  @override
  String get set_prayer => 'לקבוע תפילה';

  @override
  String get legalese => '© כל הזכויות שמורות לדניאל הוניגשטיין 2023';

  @override
  String get all_licenses => 'כל הרשיונות';

  @override
  String get finished => 'סיימתי';

  @override
  String get app_action => 'האפליקציה משמיעה את תפילת הדרך בזמן שאתם קובעים.';

  @override
  String get app_upload => 'אתם יכולים גם להעלות הקלטה שלכם.';

  @override
  String get app_free => 'האפליקציה חינמית והקוד שלה פתוח:';

  @override
  String get app_code => 'צפו בקוד';

  @override
  String get app_website => 'יש עוד דברים מעניינים באתר שלי';

  @override
  String get my_website => 'אתר שלי';

  @override
  String get app_coffee => 'אם אהבתם מוזמנים לקנות לי שוקו';

  @override
  String get buy_me_a_chocolate => 'קנו לי שוקו';

  @override
  String get thank_you => 'תודה רבה!';

  @override
  String get notification_title => 'תפילת דרך אוטומטית';

  @override
  String get notification_body => 'לחצו לצפייה';

  @override
  String get no_permission => 'הרשאה לא ניתנה, תפילה לא נקבעה';

  @override
  String get rate_app => 'לדרג ולהביע דעה בגוגל פליי';

  @override
  String get app_contact => 'שאלות? בעיות? הצעות?';

  @override
  String get contact_me => 'צרו קשר';
}
