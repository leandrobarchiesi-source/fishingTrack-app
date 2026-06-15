class MoonService {
  String getMoonPhase(
    DateTime date,
  ) {
    final knownNewMoon = DateTime(
      2000,
      1,
      6,
      18,
      14,
    );

    final difference = date
            .difference(
              knownNewMoon,
            )
            .inHours /
        24.0;

    final days = difference % 29.53058867;

    if (days < 1.84566) {
      return "🌑 Luna nuova";
    }

    if (days < 5.53699) {
      return "🌒 Luna crescente";
    }

    if (days < 9.22831) {
      return "🌓 Primo quarto";
    }

    if (days < 12.91963) {
      return "🌔 Gibbosa crescente";
    }

    if (days < 16.61096) {
      return "🌕 Luna piena";
    }

    if (days < 20.30228) {
      return "🌖 Gibbosa calante";
    }

    if (days < 23.99361) {
      return "🌗 Ultimo quarto";
    }

    if (days < 27.68493) {
      return "🌘 Luna calante";
    }

    return "🌑 Luna nuova";
  }
}
