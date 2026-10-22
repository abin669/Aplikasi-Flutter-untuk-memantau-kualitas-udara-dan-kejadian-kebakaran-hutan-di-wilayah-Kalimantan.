import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const KalimantanAirFireApp());
}

class KalimantanAirFireApp extends StatelessWidget {
  const KalimantanAirFireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalimantan Air & Fire Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}