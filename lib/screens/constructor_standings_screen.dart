import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ConstructorStandingsScreen extends StatefulWidget {
  const ConstructorStandingsScreen({super.key});

  @override
  State<ConstructorStandingsScreen> createState() => _ConstructorStandingsScreenState();
}

class _ConstructorStandingsScreenState extends State<ConstructorStandingsScreen> {
  List constructors = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchConstructors();
  }

  Future<void> fetchConstructors() async {
    final url = Uri.parse('https://ergast.com/api/f1/current/constructorStandings.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      constructors = data['MRData']['StandingsTable']['StandingsLists'][0]['ConstructorStandings'];
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konstruktőri bajnokság')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: constructors.length,
              itemBuilder: (context, index) {
                final team = constructors[index];
                final name = team['Constructor']['name'];
                final points = team['points'];
                final position = team['position'];
                return ListTile(
                  leading: Text(position),
                  title: Text(name),
                  trailing: Text("$points pont"),
                );
              },
            ),
    );
  }
}
