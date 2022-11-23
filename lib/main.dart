import 'package:al_igtisam/screens/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // theme: ThemeData(
      //   fontFamily: 'Amita',
      // ),
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
