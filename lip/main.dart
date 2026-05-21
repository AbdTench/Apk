import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hijri/hijri_calendar.dart';

void main() {
  runApp(const MehrabApp());
}

class MehrabApp extends StatelessWidget {
  const MehrabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'محراب',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        fontFamily: 'Roboto',
      ),
      home: const MainLayoutScreen(),
    );
  }
}

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const MosqueFinderScreen(),
    const ChildrenSectionScreen(),
    const QuranKhatmaScreen(),
    const SpiritualGuideScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.white60,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'الدليل'),
          BottomNavigationBarItem(icon: Icon(Icons.child_care), label: 'الأطفال'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'الختمة'),
          BottomNavigationBarItem(icon: Icon(Icons.psychology), label: 'المرشد'),
        ],
      ),
    );
  }
}

// 1. الشاشة الرئيسية مع الوجبات الذكية وأوقات الصلاة
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var _today = HijriCalendar.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text('محراب - المساعد الروحي', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.teal.shade800,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(_today.toFormat("dd MMMM yyyy AH"), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(DateFormat('yyyy-MM-dd').format(DateTime.now()), style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('مواقيت الصلاة اليوم', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildPrayerRow('الفجر', '04:12 AM'),
            _buildPrayerRow('الظهر', '12:05 PM'),
            _buildPrayerRow('العصر', '03:40 PM'),
            _buildPrayerRow('المغرب', '06:55 PM'),
            _buildPrayerRow('العشاء', '08:25 PM'),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerRow(String name, String time) {
    return Card(
      color: const Color(0xFF1E293B),
      child: ListTile(
        title: Text(name, style: const TextStyle(color: Colors.white)),
        trailing: Text(time, style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// 2. دليل المساجد والقبلة
class MosqueFinderScreen extends StatelessWidget {
  const MosqueFinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('دليل المساجد والقبلة', style: TextStyle(color: Colors.white)), backgroundColor: const Color(0xFF1E293B)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.explore, size: 100, color: Colors.tealAccent),
            const SizedBox(height: 20),
            const Text('اتجاه القبلة: 185° جنوب غرب', style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.my_location),
              label: const Text('البحث عن أقرب مسجد'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            )
          ],
        ),
      ),
    );
  }
}

// 3. قسم الأطفال والتتبع التفاعلي
class ChildrenSectionScreen extends StatefulWidget {
  const ChildrenSectionScreen({super.key});

  @override
  State<ChildrenSectionScreen> createState() => _ChildrenSectionScreenState();
}

class _ChildrenSectionScreenState extends State<ChildrenSectionScreen> {
  int points = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('صديق الصغار', style: TextStyle(color: Colors.white)), backgroundColor: const Color(0xFF1E293B)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: Colors.amber.shade700,
              child: ListTile(
                leading: const Icon(Icons.stars, color: Colors.white, size: 40),
                title: const Text('نقاط البطل اليومية', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                trailing: Text('$points ن', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('هل صليت الفروض اليوم؟', style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'].map((prayer) {
                return ElevatedButton(
                  onPressed: () => setState(() => points += 10),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: Text(prayer),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}

// 4. منظم الختمة الذكي
class QuranKhatmaScreen extends StatelessWidget {
  const QuranKhatmaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('منظم الختمة الذكي', style: TextStyle(color: Colors.white)), backgroundColor: const Color(0xFF1E293B)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              color: Color(0xFF1E293B),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('الهدف: ختم القرآن خلال 30 يوم\nمعدل القراءة اليومي: 20 صفحة (جزء كامل)', style: TextStyle(color: Colors.white, fontSize: 16), textAlign: Center),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('سجل قراءة ورد اليوم'),
            )
          ],
        ),
      ),
    );
  }
}

// 5. المساعد الروحي بالذكاء الاصطناعي
class SpiritualGuideScreen extends text {
  const SpiritualGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المرشد الروحي الذكي', style: TextStyle(color: Colors.white)), backgroundColor: const Color(0xFF1E293B)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('بماذا تشعر اليوم؟ اكتب مشاعرك وسيقوم محراب بتوجيهك للآيات والأدعية المناسبة.', style: TextStyle(color: Colors.white70), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'مثال: أشعر بالقلق والضيق...',
                hintStyle: TextStyle(color: Colors.white30),
                filled: true,
                fillColor: Color(0xFF1E293B),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('استشر المرشد الروحي'),
            )
          ],
        ),
      ),
    );
  }
}
abstract class text extends StatelessWidget { const text({super.key}); }
