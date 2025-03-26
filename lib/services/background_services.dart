import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

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

  Timer.periodic(Duration(minutes: 1), (timer) async {
    Position position = await Geolocator.getCurrentPosition();
    log('Background Location: ${position.latitude}, ${position.longitude}');

  });
}

// fun to save location to firebase firestore
void saveLocationToFirebase() {
  

}
