import 'package:flutter/material.dart';
import 'package:reminderStarter/list/reminderList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // primarySwatch: Colors.indigo[900],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: reminderList(),
    );
  }
}
