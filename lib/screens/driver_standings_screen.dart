import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DriverStandingsScreen extends StatefulWidget {
  const DriverStandingsScreen({super.key});

  @override
  State<DriverStandingsScreen> createState() => _DriverStandingsScreenState();
}

class _DriverStandingsScreenState extends State<DriverStandingsScreen> {
  List drivers = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchStandings();
  }

  Future<void> fetchStandings() async {
    final url = Uri.parse('https://ergast.com/api/f1/current/driverStandings.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      drivers = data['MRData']['StandingsTable']['StandingsLists'][0]['DriverStandings'];
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pontverseny')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: drivers.length,
              itemBuilder: (context, index) {
                final driver = drivers[index];
                final name = "${driver['Driver']['givenName']} ${driver['Driver']['familyName']}";
                final points = driver['points'];
                final position = driver['position'];
                final team = driver['Constructors'][0]['name'];
                return ListTile(
                  leading: Text(position),
                  title: Text(name),
                  subtitle: Text(team),
                  trailing: Text("$points pont"),
                );
              },
            ),
    );
  }
}
