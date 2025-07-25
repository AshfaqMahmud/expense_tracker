import 'package:expense_tracker/features/navigation/main_scaffold.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'poppins',

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: MainScaffold(),
    );
  }
}
