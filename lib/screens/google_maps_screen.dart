import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController? _controller;
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    _controller?.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Map")),
      body:
          _currentPosition == null
              ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Loading the map'), CircularProgressIndicator()],
                ),
              )
              : GoogleMap(
                initialCameraPosition: CameraPosition(target: _currentPosition!, zoom: 15),
                myLocationEnabled: true,
              ),
    );
  }
}
