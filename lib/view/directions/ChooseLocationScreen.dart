// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';

class ChooseLocationScreen extends StatefulWidget {
  final String choose;
  final MFLatLng? location;
  final BuildContext context;
  const ChooseLocationScreen(
      {super.key, required this.choose, this.location, required this.context});

  @override
  State<ChooseLocationScreen> createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  late MFMapViewController controller;
  MFLatLng? choosePossition;
  @override
  void initState() {
    super.initState();
    widget.location != null
        ? choosePossition = widget.location
        : choosePossition = const MFLatLng(16.036505, 108.218186);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Center(
          child: Text(
            widget.choose == 'start' ? 'Chọn vị trí bắt đầu' : 'Chọn điểm đến',
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // ignore: avoid_print
              print("choosePossition: $choosePossition");
              Navigator.pop(context, [widget.context, choosePossition]);
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          MFMapView(
            initialCameraPosition: MFCameraPosition(
              target: widget.location ?? const MFLatLng(16.036505, 108.218186),
              zoom: 13.0,
            ),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onMapCreated: (controller) => this.controller = controller,
            onCameraMove: (position) {
              setState(() {
                choosePossition = MFLatLng(
                    position.target.latitude, position.target.longitude);
              });
            },
          ),
          const Center(
            child: Icon(
              Icons.location_pin,
              size: 45,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
