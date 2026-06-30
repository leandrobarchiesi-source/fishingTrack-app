import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  final double? temperatura;
  final double? pressione;
  final String? vento;
  final String? condizioni;

  WeatherData({
    this.temperatura,
    this.pressione,
    this.vento,
    this.condizioni,
  });
}

class WeatherService {
  String direzioneVento(
    double gradi,
  ) {
    if (gradi < 22.5) return "N";
    if (gradi < 67.5) return "NE";
    if (gradi < 112.5) return "E";
    if (gradi < 157.5) return "SE";
    if (gradi < 202.5) return "S";
    if (gradi < 247.5) return "SW";
    if (gradi < 292.5) return "W";
    if (gradi < 337.5) return "NW";

    return "N";
  }

  String descrizioneMeteo(
    int code,
  ) {
    switch (code) {
      case 0:
        return "Sereno";

      case 1:
      case 2:
        return "Poco nuvoloso";

      case 3:
        return "Coperto";

      case 45:
      case 48:
        return "Nebbia";

      case 61:
      case 63:
      case 65:
        return "Pioggia";

      case 95:
        return "Temporali";

      default:
        return "Variabile";
    }
  }

  Future<WeatherData> getWeather({
    required double lat,
    required double lon,
    required DateTime data,
    required DateTime oraInizio,
  }) async {
    final oggi = DateTime.now();

    final giornoRichiesto = DateTime(
      data.year,
      data.month,
      data.day,
    );

    final giornoOggi = DateTime(
      oggi.year,
      oggi.month,
      oggi.day,
    );

    final dataString = "${data.year}-"
        "${data.month.toString().padLeft(2, '0')}-"
        "${data.day.toString().padLeft(2, '0')}";

    String endpoint;

    if (giornoRichiesto.isBefore(giornoOggi)) {
      endpoint = "https://archive-api.open-meteo.com/v1/archive"
          "?latitude=$lat"
          "&longitude=$lon"
          "&start_date=$dataString"
          "&end_date=$dataString"
          "&hourly="
          "temperature_2m,"
          "surface_pressure,"
          "weather_code,"
          "wind_speed_10m,"
          "wind_direction_10m"
          "&timezone=auto";
    } else {
      endpoint = "https://api.open-meteo.com/v1/forecast"
          "?latitude=$lat"
          "&longitude=$lon"
          "&hourly="
          "temperature_2m,"
          "surface_pressure,"
          "weather_code,"
          "wind_speed_10m,"
          "wind_direction_10m"
          "&timezone=auto";
    }

    final response = await http.get(
      Uri.parse(
        endpoint,
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Errore meteo",
      );
    }

    final json = jsonDecode(
      response.body,
    );

    final hourly = json["hourly"];

    final times = List<String>.from(
      hourly["time"],
    );

    int indice = 0;

    for (int i = 0; i < times.length; i++) {
      final t = DateTime.parse(
        times[i],
      );

      if (t.year == oraInizio.year &&
          t.month == oraInizio.month &&
          t.day == oraInizio.day &&
          t.hour == oraInizio.hour) {
        indice = i;
        break;
      }
    }

    final ventoDir = direzioneVento(
      hourly["wind_direction_10m"][indice].toDouble(),
    );

    return WeatherData(
      temperatura: hourly["temperature_2m"][indice].toDouble(),
      pressione: hourly["surface_pressure"][indice].toDouble(),
      vento: "${hourly["wind_speed_10m"][indice]} km/h $ventoDir",
      condizioni: descrizioneMeteo(
        hourly["weather_code"][indice],
      ),
    );
  }
}
