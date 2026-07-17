import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  ConnectivityService._();

  static final ValueNotifier<bool> online = ValueNotifier(true);

  static StreamSubscription<List<ConnectivityResult>>? _subscription;

  static Future<void> initialize() async {
    online.value = await isOnline();

_subscription ??=
    Connectivity().onConnectivityChanged.listen((result) {
  online.value = !result.contains(ConnectivityResult.none);
});
  }

  static Future<bool> isOnline() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}