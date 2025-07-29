import 'dart:async';

import 'package:app_links/app_links.dart';

class DeepLinkManager {
  static final DeepLinkManager _instance = DeepLinkManager._internal();
  factory DeepLinkManager() => _instance;
  DeepLinkManager._internal();

  bool _initialized = false;
  late AppLinks _appLinks;
  late StreamSubscription<Uri> _subscription;
  bool handledInitialLink = false;

  void init(AppLinks appLinks, Future<void> Function(Uri) onUri) async {
    if (_initialized) return;
    _initialized = true;
    _appLinks = appLinks;

    Uri? initialLink = await _appLinks.getInitialLink();

    if (initialLink != null) {
      await onUri(initialLink);
      initialLink = null; // Clear initial link after handling.
    }

    _subscription = _appLinks.uriLinkStream.listen((uri) {
      print("HOME DeepLinkManager received URI: $uri");
      if (initialLink == null) {
        onUri(uri);
      }
    });
  }

  void dispose() {
    _initialized = false;
    _subscription.cancel();
  }
}
