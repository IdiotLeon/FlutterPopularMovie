import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  static const routeName = "/mapPage";

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  Completer<GoogleMapController> controller = Completer();

  static const LatLng center = const LatLng(45.521563, -122.677433);

  MapType currentMapType = MapType.normal;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;

  var location = new Location();
  LocationData userLocation;

  void onMapTypeButtonPressed() {
    setState(() {
      currentMapType =
          currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  void _add(LatLng location) {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        location.latitude + sin(_markerIdCounter * pi / 6.0) / 20.0,
        location.longitude + cos(_markerIdCounter * pi / 6.0) / 20.0,
      ),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
        _onMarkerTapped(markerId);
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _remove() {
    setState(() {
      if (markers.containsKey(selectedMarker)) {
        markers.remove(selectedMarker);
      }
    });
  }

  void onMapCreated(GoogleMapController controller) {
    this.controller.complete(controller);

    getLocation().then((onValue) {
      userLocation = onValue;
      print('getLocation(): ' + userLocation.latitude.toString());
      print('getLocation(): ' + userLocation.longitude.toString());
    });

    location.onLocationChanged().listen((onData) {
      print(onData.latitude);
      print(onData.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: this.onMapCreated,
          initialCameraPosition: CameraPosition(target: center, zoom: 11.0),
          mapType: currentMapType,
          markers: Set<Marker>.of(markers.values),
          onTap: _add,
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

  Future<LocationData> getLocation() async {
    LocationData currentLocation;
    var location = new Location();

    try {
      currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }

      currentLocation = null;
    }

    return currentLocation;
  }
}

class PlaceMarkerBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlaceMarkerBodyState();
}

class PlaceMarkerBodyState extends State<PlaceMarkerBody> {
  PlaceMarkerBodyState();

  static final LatLng center = const LatLng(-33.86711, 151.1947171);

  GoogleMapController controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  void _add() {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        center.latitude + sin(_markerIdCounter * pi / 6.0) / 20.0,
        center.longitude + cos(_markerIdCounter * pi / 6.0) / 20.0,
      ),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
        _onMarkerTapped(markerId);
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _remove() {
    setState(() {
      if (markers.containsKey(selectedMarker)) {
        markers.remove(selectedMarker);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
