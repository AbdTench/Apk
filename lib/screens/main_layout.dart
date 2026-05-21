import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'qibla_mosque_screen.dart';
import 'children_screen.dart';
import 'spiritual_guide_screen.dart';
import 'khatma_screen.dart';
import '../widgets/home_widgets.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const QiblaMosqueScreen(),
    const ChildrenScreen(),
    const SpiritualGuideScreen(),
    const KhatmaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    HijriCalendar.setLocal('ar');
    final todayHijri = HijriCalendar.now();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("MEHRAB", style: TextStyle(fontWeight: FontWeight.black, letterSpacing: 1.5, fontSize: 20)),
            Text(
              "${todayHijri.hDay} ${todayHijri.longMonthName} ${todayHijri.hYear} AH",
              style: TextStyle(color: theme.colorScheme.secondary, fontSize: 12, fontWeight: FontWeight.bold),
            )
          ],
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 4,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        indicatorColor: theme.colorScheme.secondary.withOpacity(0.3),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Live"),
          NavigationDestination(icon: Icon(Icons.explore), label: "Qibla"),
          NavigationDestination(icon: Icon(Icons.child_care), label: "Kids Club"),
          NavigationDestination(icon: Icon(Icons.auto_awesome), label: "AI Advisor"),
          NavigationDestination(icon: Icon(Icons.menu_book), label: "Khatma"),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const HomeWidgetChassis(layoutStyle: "Hijri Calendar"),
          const SizedBox(height: 16),
          const HomeWidgetChassis(layoutStyle: "Daily Quran & Dua"),
          const SizedBox(height: 16),
          const HomeWidgetChassis(layoutStyle: "Prayer Times"),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.spa, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text("Daily Remembrance (Dhikr)", style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const Divider(),
                  const Text(
                    "أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ",
                    style: TextStyle(fontFamily: 'Serif', fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "\"Unquestionably, by the remembrance of Allah hearts are assured.\" (Quran 13:28)",
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
