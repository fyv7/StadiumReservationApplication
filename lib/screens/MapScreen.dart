import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/stadium_model.dart';

class MapScreen extends StatefulWidget {
  final Stadium stadium;

  const MapScreen({super.key, required this.stadium});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _permissionGranted = false; // Tracks the status of location permission.

  @override
  void initState() {
    super.initState();
    _requestLocationPermission(); // Requests location permission when the widget is initialized.
  }

  // Asynchronously requests location permission from the user.
  Future<void> _requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status; // Checks the current permission status.
    if (!status.isGranted) {
      // If not granted, requests permission.
      status = await Permission.locationWhenInUse.request();
    }
    if (mounted) {
      // Checks if the widget is still part of the widget tree.
      setState(() {
        // Updates the state with the new permission status.
        _permissionGranted = status.isGranted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("stadium Location"), // Sets the app bar title.
      ),
      body: _permissionGranted
          ? GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.stadium.stadiumData!.latitude!, widget.stadium.stadiumData!.longitude!),
          zoom: 5.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('stadiumMarker'),
            position: LatLng(widget.stadium.stadiumData!.latitude!, widget.stadium.stadiumData!.longitude!),
            infoWindow: InfoWindow(title: widget.stadium.stadiumData!.name!),
          ),
        },
        myLocationEnabled: true, // Enables the 'My Location' button.
        myLocationButtonEnabled: true, // Shows the 'My Location' button if permission is granted.
      )
          : const Center(
        child: Text("Location permission is required to show the map."),
        // Displays a message if location permission is not granted.
      ),
    );
  }
}
