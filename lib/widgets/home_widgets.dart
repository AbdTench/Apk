import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';
import '../blocs/mehrab_bloc.dart';

class HomeWidgetChassis extends StatelessWidget {
  final String layoutStyle;

  const HomeWidgetChassis({
    super.key,
    required this.layoutStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hour = DateTime.now().hour;

    // Categorize dynamic Morning, Noon, Night layouts
    String dynamicTimeCategory = "Night";
    if (hour >= 5 && hour < 11) {
      dynamicTimeCategory = "Morning";
    } else if (hour >= 11 && hour < 17) {
      dynamicTimeCategory = "Noon";
    }

    return BlocBuilder<MehrabBloc, MehrabState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF0C4A34), // Rich theme deep green
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 6),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: _buildWidgetContents(context, state, dynamicTimeCategory),
        );
      },
    );
  }

  Widget _buildWidgetContents(BuildContext context, MehrabState state, String timeOfDay) {
    final theme = Theme.of(context);
    HijriCalendar.setLocal('ar');
    final todayHijri = HijriCalendar.now();

    switch (layoutStyle) {
      case "Hijri Calendar":
        String bannerText = (timeOfDay == "Morning")
            ? "🌅 Fajr duas are answered"
            : (timeOfDay == "Noon")
                ? "☀️ Rest and recite your midday Dhikr"
                : "🌙 Night of forgiveness; sleep with Wudu";

        return Column(
          children: [
            Text(
              "HIJRI CALENDAR",
              style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.black, fontSize: 10, letterSpacing: 1.5),
            ),
            const SizedBox(height: 8),
            Text(
              "${todayHijri.hDay} ${todayHijri.longMonthName} ${todayHijri.hYear} AH",
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              "Gregorian: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
              style: const TextStyle(color: Colors.white60, fontSize: 10),
            ),
            const Divider(color: Colors.white12),
            Text(
              bannerText,
              style: TextStyle(color: theme.colorScheme.secondary, fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          ],
        );

      case "Daily Quran & Dua":
        String header;
        String arabic;
        String english;

        if (timeOfDay == "Morning") {
          header = "🌅 MORNING QURANIC DEVOTION";
          arabic = "فَسُبْحَانَ اللَّهِ حِينَ تُمْسُونَ وَحِينَ تُصْبِحُونَ";
          english = "\"So glorify Allah when you reach evening and when you reach morning.\" (Quran 30:17)";
        } else if (timeOfDay == "Noon") {
          header = "☀️ MIDDAY FAITHFUL REFLECTION";
          arabic = "أَقِمِ الصَّلَاةَ لِدُلُوكِ الشَّمْسِ إِلَىٰ غَسَقِ اللَّيْلِ";
          english = "\"Establish prayer at the decline of the sun [midday].\" (Quran 17:78)";
        } else {
          header = "🌙 NIGHT DUA & PROTECTION";
          arabic = "وَسَبِّحْ بِحَمْدِ رَبِّكَ قَبْلَ طُلُوعِ الشَّمْسِ وَقَبْلَ غُرُوبِهَا";
          english = "\"And glorify your Lord with praise before sunrise and before sunset.\" (Quran 20:130)";
        }

        return Column(
          children: [
            Text(
              header,
              style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.black, fontSize: 10, letterSpacing: 1.5),
            ),
            const SizedBox(height: 12),
            Text(
              arabic,
              style: const TextStyle(fontFamily: 'Serif', color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              english,
              style: const TextStyle(color: Colors.white70, fontSize: 10, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        );

      case "Prayer Times":
      default:
        return Column(
          children: [
            Text(
              "TODAY'S CONGREGATIONAL TIMES",
              style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.black, fontSize: 10, letterSpacing: 1.5),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPrayerTimeCol("Fajr", state.prayerTimes.fajr),
                _buildPrayerTimeCol("Dhuhr", state.prayerTimes.dhuhr),
                _buildPrayerTimeCol("Asr", state.prayerTimes.asr),
                _buildPrayerTimeCol("Maghrib", state.prayerTimes.maghrib),
                _buildPrayerTimeCol("Isha", state.prayerTimes.isha),
              ],
            )
          ],
        );
    }
  }

  Widget _buildPrayerTimeCol(String name, String value) {
    return Column(
      children: [
        Text(name, style: const TextStyle(color: Colors.white60, fontSize: 10)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }
}
