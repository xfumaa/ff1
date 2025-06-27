import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> sessions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchRaceSchedule();
  }

  Future<void> fetchRaceSchedule() async {
    final url = Uri.parse('https://ergast.com/api/f1/current/next.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final race = data['MRData']['RaceTable']['Races'][0];

      final sessionsTemp = [
        {'title': '1. szabadedzés', 'time': race['FirstPractice']?['date'] + ' ' + race['FirstPractice']?['time'] ?? ''},
        {'title': '2. szabadedzés', 'time': race['SecondPractice']?['date'] + ' ' + race['SecondPractice']?['time'] ?? ''},
        {'title': '3. szabadedzés', 'time': race['ThirdPractice']?['date'] + ' ' + race['ThirdPractice']?['time'] ?? ''},
        {'title': 'Időmérő', 'time': race['Qualifying']?['date'] + ' ' + race['Qualifying']?['time'] ?? ''},
        {'title': 'Futam', 'time': race['date'] + ' ' + race['time']},
      ];

      setState(() {
        sessions = sessionsTemp;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  String formatDateTime(String utcString) {
    try {
      final dt = DateTime.parse(utcString).toLocal();
      return DateFormat('yyyy. MM. dd. – HH:mm', 'hu').format(dt);
    } catch (_) {
      return 'Ismeretlen időpont';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('F1 Hétvége')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return ListTile(
                  title: Text(session['title'] ?? ''),
                  subtitle: Text(formatDateTime(session['time'] ?? '')),
                );
              },
            ),
    );
  }
}
