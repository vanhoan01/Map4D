// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map4d_map/map4d_map.dart';
import 'package:map4dmap/screens/directionsRenderer/DirectionsRendererScreen.dart';

class locationGeolocator extends StatefulWidget {
  const locationGeolocator({Key? key}) : super(key: key);

  @override
  State<locationGeolocator> createState() => _locationGeolocatorState();
}

class _locationGeolocatorState extends State<locationGeolocator> {
  late MFMapViewController controller;
  bool _is3dMode = false;

  MFLatLng _kLatLng = MFLatLng(16.0324816, 108.132794);
  MFBitmap? _markerIcon;
  Map<MFMarkerId, MFMarker> markers = <MFMarkerId, MFMarker>{};
  late LocationSettings locationSettings;
  StreamSubscription<Position>? _positionStream;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  @override
  void initState() {
    getUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset(context);
    return Scaffold(
      body: MFMapView(
        initialCameraPosition: MFCameraPosition(
          target: _kLatLng,
          zoom: 13.0,
        ),
        markers: Set<MFMarker>.of(markers.values),
        onMapCreated: _onMapCreated,
        onPOITap: _onPOITap,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            child: const Icon(Icons.my_location),
            onPressed: () {
              getUserLocation();
              // controller.moveCamera(MFCameraUpdate.newLatLng(_kLatLng!));
              _addLocationIcon();
              controller
                  .animateCamera(MFCameraUpdate.newLatLngZoom(_kLatLng, 17));
              // _listenLocationUpdates();
            },
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DirectionsRendererScreen()),
              );
            },
            tooltip: 'Directions',
            child: const Icon(Icons.directions),
          ),
        ],
      ),
    );
  }

  void _listenLocationUpdates() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 1,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }
    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      print(position);
    });
  }

  void _addLocationIcon() {
    final String markerIdVal = 'my_location';
    final MFMarkerId markerId = MFMarkerId(markerIdVal);

    //khởi tạo marker
    final MFMarker marker = MFMarker(
      consumeTapEvents: true,
      markerId: markerId,
      position: _kLatLng,
      icon: _markerIcon!,
      infoWindow: MFInfoWindow(
          snippet: "Snippet $_kLatLng",
          title: "Map4D",
          anchor: const Offset(0.5, 0.0),
          onTap: () {
            _onInfoWindowTapped(markerId);
          }),
      zIndex: 1.0,
    );
    setState(() {
      markers = <MFMarkerId, MFMarker>{};
      markers[markerId] = marker;
    });
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size.square(48));
      _markerIcon = await MFBitmap.fromAssetImage(
          imageConfiguration, 'assets/ic_my_location.png');
    }
  }

  void _onInfoWindowTapped(MFMarkerId markerId) {
    print("Did tap info window of " + markerId.value);
  }

  void _onMapCreated(MFMapViewController controller) {
    this.controller = controller;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    print(position.longitude);
    return position;
  }

  void getUserLocation() async {
    try {
      Position currentLocation = await _determinePosition();
      setState(() {
        _kLatLng =
            MFLatLng(currentLocation.latitude, currentLocation.longitude);
      });
    } catch (e) {
      print(e);
    }
  }

  void _switch3dMode() async {
    _is3dMode = !_is3dMode;
    // ignore: deprecated_member_use
    controller.enable3DMode(_is3dMode);
  }

  void _onPOITap(String placeId, String name, MFLatLng location) {
    print('Tap on place: $placeId, name: $name, location: $location');
  }
}
