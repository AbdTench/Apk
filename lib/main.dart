import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blocs/mehrab_bloc.dart';
import 'screens/main_layout.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Local Notifications safely
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  final prefs = await SharedPreferences.getInstance();

  runApp(MehrabApp(prefs: prefs));
}

class MehrabApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MehrabApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MehrabBloc(prefs)..add(InitializeMehrabEvent()),
      child: MaterialApp(
        title: 'Mehrab',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0C4A34), // Rich Emerald Green
            primary: const Color(0xFF0C4A34),
            secondary: const Color(0xFFD4AF37), // Islamic Gold
            background: const Color(0xFFF4F6F4),
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontFamily: 'Sans-Serif'),
          ),
        ),
        home: const MainLayout(),
      ),
    );
  }
}
