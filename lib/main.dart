import 'package:flutter/material.dart';
import 'package:myapi_app/api/api.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyAPIApp(),);
  }
}