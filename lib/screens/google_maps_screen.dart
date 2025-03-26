import 'package:cloud_firestore/cloud_firestore.dart';
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
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadMarkers();
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

  Future<List<Marker>> _fetchMarkers() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('current_location').get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Marker(
        markerId: MarkerId(doc.id),
        position: LatLng(data['latitude'], data['longitude']),
        infoWindow: InfoWindow(title: "Saved Location", snippet: data['timestamp']),
      );
    }).toList();
  }

  // fun to set the marks
  Future<void> _loadMarkers() async {
    List<Marker> markersList = await _fetchMarkers();
    setState(() {
      markers.addAll(markersList);
    });
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
                  children: [
                    Text('Loading the map'),
                    SizedBox(width: 4),
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.black),
                    ),
                  ],
                ),
              )
              : GoogleMap(
                initialCameraPosition: CameraPosition(target: _currentPosition!, zoom: 15),
                myLocationEnabled: true,
                markers: markers,
              ),
    );
  }

}
