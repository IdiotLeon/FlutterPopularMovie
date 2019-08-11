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

  MapType currentMapType = MapType.normal;

  void onMapTypeButtonPressed() {
    setState(() {
      currentMapType =
          currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  void onMapCreated(GoogleMapController controller) {
    this.controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: this.onMapCreated,
          initialCameraPosition: CameraPosition(target: center, zoom: 11.0),
          mapType: currentMapType,
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              children: <Widget>[
                FloatingActionButton(
                  onPressed: onMapTypeButtonPressed,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.map, size: 36.0),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
