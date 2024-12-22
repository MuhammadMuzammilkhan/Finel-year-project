import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  static const LatLng _storeLocation = LatLng(37.7749, -122.4194); // Example: San Francisco

  late GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Store Location"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: _storeLocation,
              zoom: 15,
            ),
            markers: {
              Marker(
                markerId: const MarkerId("storeLocation"),
                position: _storeLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                infoWindow: const InfoWindow(title: "Our Store"),
              ),
            },
          ),
          const Center(
            child: Icon(
              Icons.location_on,
              color: Colors.redAccent,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
