import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.appName,
    required this.version,
    required this.copyright,
  });

  final String appName;
  final String version;
  final String copyright;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        actions: [
          TextButton(
              onPressed: () {
                showLicensePage(context: context);
              },
              child: Text("כל הרשיונות")),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("סיימתי")),
        ],
        title: Text(
          "$appName $version",
          textAlign: TextAlign.center,
        ),
        content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(copyright),
              SizedBox(
                height: 10,
              ),
              const Text("האפליקציה משמיעה את תפילת הדרך בזמן שאתם קובעים."),
              const Text("אתם יכולים גם להעלות הקלטה שלכם."),
              const Text("האפליקציה חינמית והקוד שלה פתוח:"),
              Link(
                  uri: Uri.parse(
                      "https://github.com/danielle-h/auto-tefilat-haderech"),
                  target: LinkTarget.defaultTarget,
                  builder: (BuildContext ctx, FollowLink? openLink) {
                    return TextButton(
                        onPressed: openLink, child: Text("צפו בקוד"));
                  }),
              const Text("יש עוד דברים מעניינים באתר שלי"),
              Link(
                  uri: Uri.parse("https://danielle-honig.com/"),
                  target: LinkTarget.defaultTarget,
                  builder: (BuildContext ctx, FollowLink? openLink) {
                    return TextButton(
                        onPressed: openLink, child: Text("אתר שלי"));
                  }),
              const Text(
                  "אם אהבתם מוזמנים לקנות לי שוקו: (אני לא אוהבת קפה ;) )"),
              Link(
                  uri: Uri.parse("https://www.buymeacoffee.com/369wkrttu6"),
                  target: LinkTarget.defaultTarget,
                  builder: (BuildContext ctx, FollowLink? openLink) {
                    return TextButton(
                        onPressed: openLink, child: Text("קנו לי שוקו"));
                  }),
              Text(
                "תודה רבה!",
                textAlign: TextAlign.center,
              ),
            ]),
      ),
    );
  }
}
