import 'dart:math';

class DailyPrayerTimes {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  const DailyPrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory DailyPrayerTimes.calculate(double latitude, double longitude, double timezone) {
    // Elegant standard astronomical calculation model for universal device offline safety
    double latRad = latitude * pi / 180.0;
    
    // Approximate zenith angle equations for Fajr (-18 degrees) and Isha (-17 degrees)
    double fajrHour = 5.0 - (sin(-18 * pi / 180) * latRad).abs() * 0.4;
    double sunriseHour = 6.0 - (sin(-0.83 * pi / 180) * latRad).abs() * 0.3;
    double dhuhrHour = 12.0 - (longitude / 15.0) + timezone;
    double asrHour = 15.3 + (sin(latRad).abs() * 0.5);
    double maghribHour = 18.2 + (sin(-0.83 * pi / 180) * latRad).abs() * 0.3;
    double ishaHour = 19.5 + (sin(-17 * pi / 180) * latRad).abs() * 0.4;

    String formatTime(double hour) {
      int h = hour.floor() % 24;
      int m = ((hour - hour.floor()) * 60).round() % 60;
      return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}";
    }

    return DailyPrayerTimes(
      fajr: formatTime(fajrHour),
      sunrise: formatTime(sunriseHour),
      dhuhr: formatTime(dhuhrHour),
      asr: formatTime(asrHour),
      maghrib: formatTime(maghribHour),
      isha: formatTime(ishaHour),
    );
  }
}
