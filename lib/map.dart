import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  static const routeName = "/mapPage";

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  Completer<GoogleMapController> controller = Completer();

  static const LatLng center = const LatLng(45.521563, -122.677433);

  void onMapCreated(GoogleMapController controller) {
    this.controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GoogleMap(
        onMapCreated: this.onMapCreated,
        initialCameraPosition: CameraPosition(target: center, zoom: 11.0),
      ),
    );
  }
}
