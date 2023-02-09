// ignore_for_file: file_names, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map4d_map/map4d_map.dart';
import 'package:map4dmap/model/model/PlaceDetail.dart';
import 'package:map4dmap/view/screens/directionsRenderer/DirectionsRendererScreen.dart';
import 'package:map4dmap/view_model/PlaceDetailViewModel.dart';

// ignore: camel_case_types
class locationGeolocator extends StatefulWidget {
  const locationGeolocator({Key? key}) : super(key: key);

  @override
  State<locationGeolocator> createState() => _locationGeolocatorState();
}

// ignore: camel_case_types
class _locationGeolocatorState extends State<locationGeolocator> {
  late MFMapViewController controller;

  MFLatLng _kLatLng = const MFLatLng(16.0324816, 108.132794);
  MFBitmap? _markerIcon;
  Map<MFMarkerId, MFMarker> markers = <MFMarkerId, MFMarker>{};
  late LocationSettings locationSettings;
  final PlaceDetailViewModel placeDetailViewModel = PlaceDetailViewModel();
  PlaceDetail? _placeDetail;

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
        onTap: _onTap,
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

  void _addLocationIcon() {
    const String markerIdVal = 'my_location';
    const MFMarkerId markerId = MFMarkerId(markerIdVal);

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
          createLocalImageConfiguration(context, size: const Size.square(48));
      _markerIcon = await MFBitmap.fromAssetImage(
          imageConfiguration, 'assets/ic_my_location.png');
    }
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

  void _onInfoWindowTapped(MFMarkerId markerId) {
    print("Did tap info window of ${markerId.value}");
  }

  void _onTap(MFLatLng coordinate) {
    print('coordinate: $coordinate');
  }

  Future<void> _onPOITap(String placeId, String name, MFLatLng location) async {
    print('id');
    PlaceDetail placeDetail =
        await placeDetailViewModel.getPlaceDetail(placeId);
    print('id ${placeDetail.id}, address ${placeDetail.address}');
    setState(() {
      _placeDetail = placeDetail;
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      builder: (context) {
        return bottomDetailsSheet();
      },
    );
  }

  Widget bottomDetailsSheet() {
    return DraggableScrollableSheet(
      initialChildSize: .17,
      minChildSize: .17,
      maxChildSize: 0.97,
      snap: true,
      snapSizes: const [0.7],
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10.0),
                topLeft: Radius.circular(10.0),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5.0,
                  spreadRadius: 20.0,
                  offset: const Offset(0.0, 5.0),
                  color: Colors.black.withOpacity(0.1),
                )
              ],
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      height: 5,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _placeDetail!.name,
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
                const SizedBox(height: 10),
                Text(
                  'Loại: ${_placeDetail!.types[0]}',
                  style: const TextStyle(
                      fontSize: 15, color: Color.fromRGBO(117, 117, 117, 1)),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DirectionsRendererScreen(
                            destination: _placeDetail,
                          ),
                        ),
                      );
                    });
                  },
                  icon: const Icon(Icons.directions),
                  label: const Text(
                    'Đường đi',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                    backgroundColor: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 1,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.location_on_outlined,
                          color: Colors.blueAccent,
                        )),
                    Expanded(
                      child: Text(
                        _placeDetail!.address,
                        style: const TextStyle(
                            fontSize: 14, color: Color.fromRGBO(66, 66, 66, 1)),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
