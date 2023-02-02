// ignore_for_file: avoid_print, file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: camel_case_types
class locationLocation extends StatefulWidget {
  const locationLocation({super.key});

  @override
  State<locationLocation> createState() => _locationLocationState();
}

// ignore: camel_case_types
class _locationLocationState extends State<locationLocation> {
  final Completer<GoogleMapController> _controller = Completer();
  // on below line we have specified camera position
  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(20.42796133580664, 80.885749655962),
    zoom: 14.4746,
  );

  // on below line we have created the list of markers
  final List<Marker> _markers = <Marker>[
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(20.42796133580664, 75.885749655962),
        infoWindow: InfoWindow(
          title: 'My Position',
        )),
  ];
  double pd = 95;

  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR $error");
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        // on below line setting camera position
        initialCameraPosition: _kGoogle,
        // on below line we are setting markers on the map
        markers: Set<Marker>.of(_markers),
        // on below line specifying map type.
        mapType: MapType.normal,
        // on below line setting user location enabled.
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        padding: EdgeInsets.only(top: pd),
        // on below line setting compass enabled.
        compassEnabled: true,
        // on below line specifying controller on map complete.
        onMapCreated: (GoogleMapController controller) {
          try {
            _controller.complete(controller);
            setState(() {
              pd = 96;
            });
          } catch (e) {
            print(e);
          }
        },
      ),
      // on pressing floating action button the camera will take to user current location
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: FloatingActionButton(
          heroTag: null,
          onPressed: () async {
            getUserCurrentLocation().then((value) async {
              print("${value.latitude} ${value.longitude}");

              // marker added for current users location
              _markers.add(Marker(
                markerId: const MarkerId("2"),
                position: LatLng(value.latitude, value.longitude),
                infoWindow: const InfoWindow(title: 'My Current Location'),
              ));

              // specified current users location
              CameraPosition cameraPosition = CameraPosition(
                target: LatLng(value.latitude, value.longitude),
                zoom: 14,
              );

              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                  CameraUpdate.newCameraPosition(cameraPosition));
              setState(() {});
            });
          },
          child: const Icon(Icons.local_activity),
        ),
      ),
    );
  }
}
