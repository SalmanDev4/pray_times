import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pray_times/data.dart';
import 'package:pray_times/json_connection.dart';

void main() {
  runApp(MaterialApp(
    home: PrayTimes(),
  ));
}

class PrayTimes extends StatefulWidget {
  PrayTimes({Key key}) : super(key: key);

  @override
  _PrayTimesState createState() => _PrayTimesState();
}

class _PrayTimesState extends State<PrayTimes> {

  JsonConnection jsonConnection = new JsonConnection();
  Data list;

  static String city = 'Dammam';
  static String country = 'Saudi Arabia';
  static int method = 4;

  final String url =
      'http://api.aladhan.com/v1/timingsByCity?city=$city&country=$country&method=$method';

  Future getPTData() async {
    http.Response res = await http.get(Uri.encodeFull(url), headers: {
      "Accept":
          "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
    });
    final data = jsonDecode(res.body);

    list = Data.fromJson(data);

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pray Times'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: jsonConnection.getPTLocation(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text('Fajr'),
                          Text('Dhuhr'),
                          Text('Asr'),
                          Text('Maghrib'),
                          Text('Isha'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(snapshot.data.data.timings.fajr),
                          Text(snapshot.data.data.timings.dhuhr),
                          Text(snapshot.data.data.timings.asr),
                          Text(snapshot.data.data.timings.maghrib),
                          Text(snapshot.data.data.timings.isha),
                        ],
                      ),
                    ),
                    Padding(padding: const EdgeInsets.all(8.0),
                    child: Column(children: <Widget>[
                      Text(snapshot.data.data.meta.timezone),
                    ],),)
                  ],
                ),
              ),
            );
          } else  {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
