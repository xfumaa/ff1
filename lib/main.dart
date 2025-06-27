import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/driver_standings_screen.dart';
import 'screens/constructor_standings_screen.dart';

void main() {
  runApp(const F1PulseApp());
}

class F1PulseApp extends StatelessWidget {
  const F1PulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F1 Pulse',
      locale: const Locale('hu'),
      supportedLocales: const [Locale('hu')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const HomeWithNavigation(),
    );
  }
}

class HomeWithNavigation extends StatefulWidget {
  const HomeWithNavigation({super.key});

  @override
  State<HomeWithNavigation> createState() => _HomeWithNavigationState();
}

class _HomeWithNavigationState extends State<HomeWithNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    DriverStandingsScreen(),
    ConstructorStandingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Hétvége',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Pontverseny',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Konstruktőri bajnokság',
          ),
        ],
      ),
    );
  }
}
