import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:myapi_app/api/data.dart';

dynamic coloraqi(dynamic aqi) {
  if (aqi <= 50) {
    return Colors.green;
  } else if (aqi <= 100) {
    return Colors.yellow;
  } else if (aqi <= 150) {
    return Colors.orange;
  } else if (aqi <= 200) {
    return Colors.red;
  } else if (aqi <= 300) {
    return Colors.purpleAccent;
  } else {
    return const Color.fromARGB(255, 69, 28, 14);
  }
}

dynamic face(dynamic face) {
  if (face <= 50) {
    return Icon(
      Icons.face,
      size: 80,
    );
  } else if (face <= 150) {
    return Icon(
      Icons.masks_outlined,
      size: 80,
    );
  } else if (face <= 300) {
    return Icon(
      Icons.masks,
      size: 80,
    );
  }
}

dynamic time(String time) {
  int t = int.parse(time.substring(time.length - 8, time.length - 6));
  if (t >= 8 && t <= 18) {
    return Icon(
      Icons.sunny,
      color: Colors.grey,
    );
  } else {
    return Icon(
      Icons.nightlight_outlined,
      color: Colors.grey,
    );
  }
}

class MyAPIApp extends StatefulWidget {
  const MyAPIApp({super.key});
  @override
  State<MyAPIApp> createState() => _MyAPIAppState();
}

class _MyAPIAppState extends State<MyAPIApp> {
  List<String> nameStation = [];
  List<Data> data = [];
  bool loading = true;
  Future<void> fetchData() async {
    setState(() {
      loading = true;
    });
    try {
      var response = await http.get(Uri.parse(
          'https://api.waqi.info/feed/here/?token=09c75c99c46efe870899898c7da522877239a2a5'));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          final local_data = Data.fromJson(json);
          data.add(local_data);
          print("refresh");
        });
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "AQI",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 35),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body:loading ? const Center(child: CircularProgressIndicator(),):
      Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 30, right: 30, top: 100),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.gps_fixed,
                    color: Colors.grey,
                  ),
                  Text(
                    '${data[0].name}',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              padding: EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: coloraqi(data[0].pm),
              ),
              child: Row(
                children: [
                  face(data[0].pm),
                  SizedBox(width: 30),
                  Text(
                    '${data[0].pm}',
                    style: TextStyle(fontSize: 60, fontWeight: FontWeight.w500),
                  ),
                ],
              )),
          Container(
            margin: EdgeInsets.only(left: 30, right: 30, top: 10),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.thermostat_outlined,
                    color: Colors.grey,
                  ),
                  Text(
                    '${data[0].temp}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  time(data[0].time),
                  Text(
                    '${data[0].time}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: () {
                fetchData();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, elevation: 0),
              child: Icon(
                Icons.refresh,
                color: Colors.grey,
                size: 40,
              ))
        ],
      ),
    );
  }
}
