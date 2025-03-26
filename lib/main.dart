import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:woodesy_assignment/firebase_options.dart';
import 'package:woodesy_assignment/screens/google_maps_screen.dart';
import 'package:woodesy_assignment/services/background_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeService();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GoogleMapScreen(),
    );
  }
}
