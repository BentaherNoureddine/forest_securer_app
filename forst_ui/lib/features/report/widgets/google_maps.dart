import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});

  @override
  State<GoogleMaps> createState() => _MyAppState();
}

class _MyAppState extends State<GoogleMaps> {

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(37.2162, 10.1143);

  void _onMapCreated(GoogleMapController controller){
    mapController =controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Office Locations'),
          elevation: 2,
        ),
        body: GoogleMap(
            onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: _center,zoom: 11.0),
    ),
    ));
  }
}
