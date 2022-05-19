import 'package:flutter/material.dart';
import 'package:github_agent/Widgets/homepage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_to_front/window_to_front.dart';  

void main() {
  runApp(
    const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Client',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'GitHub Client'),
    );
  }
}
