// ignore_for_file: camel_case_types, file_names, avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:network_info_plus/network_info_plus.dart';

class locationMap4d extends StatefulWidget {
  const locationMap4d({Key? key}) : super(key: key);

  @override
  State<locationMap4d> createState() => _locationMap4dState();
}

class _locationMap4dState extends State<locationMap4d> {
  late MFMapViewController controller;
  late GoogleMap map;
  var log = Logger();

  MFLatLng _kLatLng = const MFLatLng(16.0758426, 108.2291398);
  MFBitmap? _markerIcon;
  Map<MFMarkerId, MFMarker> markers = <MFMarkerId, MFMarker>{};

  final info = NetworkInfo();

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
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 600),
        child: FloatingActionButton(
          heroTag: null,
          child: const Icon(Icons.my_location),
          onPressed: () async {
            fetchCurentLocation();
            controller
                .animateCamera(MFCameraUpdate.newLatLngZoom(_kLatLng, 15));
            // var wifiIP = await info.getWifiIP();
            // print(wifiIP);
          },
        ),
      ),
    );
  }

  Future fetchCurentLocation() async {
    //http://ip-api.com/json/113.176.195.71
    String url =
        'https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyBOti4mM-6x9WDnZIjIeyEU21OpBXqWBgw';
    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-type": "application/json"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var body = json.decode(response.body);
      print(body);
      print("${body['location']['lat']}, ${body['location']['lng']}");

      setState(() {
        _kLatLng = MFLatLng(body['location']['lat'], body['location']['lng']);
        _addLocationIcon();
      });
    }
  }

  Future<void> _addLocationIcon() async {
    String markerIdVal = 'my_location';
    MFMarkerId markerId = MFMarkerId(markerIdVal);

    //khởi tạo marker
    // ignore: await_only_futures
    MFMarker marker = await MFMarker(
      consumeTapEvents: true,
      markerId: markerId,
      position: _kLatLng,
      icon: _markerIcon!,
      infoWindow: MFInfoWindow(
          snippet: "Snippet $_kLatLng",
          title: "Map4D",
          anchor: const Offset(0.5, 0.0),
          onTap: () {
            // _onInfoWindowTapped(markerId);
          }),
      zIndex: 1.0,
    );
    print(
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    print(_kLatLng);
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

  void _onPOITap(String placeId, String name, MFLatLng location) {
    print('Tap on place: $placeId, name: $name, location: $location');
    showAlertDialog(context, Text("location: $location"));
  }

  void _onTap(MFLatLng location) {
    showAlertDialog(context, Text("location: $location"));
  }

  showAlertDialog(BuildContext context, Text text) {
    // Create button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Địa điểm"),
      content: text,
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

//com.example.map4dmap
//9A:42:AE:D5:A6:24:DE:9B:71:5A:66:81:20:F9:A2:31:7C:19:A6:85
