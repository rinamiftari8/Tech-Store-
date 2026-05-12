import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const TechStoreApp());
}

class TechStoreApp extends StatelessWidget {
  const TechStoreApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TechStore Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
