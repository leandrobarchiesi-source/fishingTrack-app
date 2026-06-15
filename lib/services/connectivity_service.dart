import 'dart:io';

class ConnectivityService {
  static Future<bool> isOnline() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      );

      return result.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
