import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:woodesy_assignment/firebase_options.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();

  // Background location tracking logic
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  Timer.periodic(Duration(minutes: 4), (timer) async {
    Position position = await Geolocator.getCurrentPosition();
    String timestamp = DateTime.now().toIso8601String();

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // getting firebase firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Store in Firestore
    await firestore.collection('current_location').add({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': timestamp,
    });

    log('Location stored: ${position.latitude}, ${position.longitude}');
  });
}
