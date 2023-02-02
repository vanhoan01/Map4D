// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:map4dmap/drawing_map_and_layers/directions_renderer.dart';
import 'package:map4dmap/drawing_map_and_layers/image_overlay.dart';
import 'package:map4dmap/drawing_map_and_layers/page.dart';
import 'package:map4dmap/drawing_map_and_layers/place_building.dart';
import 'package:map4dmap/drawing_map_and_layers/place_circle.dart';
import 'package:map4dmap/drawing_map_and_layers/place_marker.dart';
import 'package:map4dmap/drawing_map_and_layers/place_poi.dart';
import 'package:map4dmap/drawing_map_and_layers/place_polygon.dart';
import 'package:map4dmap/drawing_map_and_layers/place_polyline.dart';
import 'package:map4dmap/drawing_map_and_layers/tile_overlay.dart';

// ignore: camel_case_types
class notificationPage extends StatefulWidget {
  const notificationPage({super.key});

  @override
  State<notificationPage> createState() => _notificationPageState();
}

// ignore: camel_case_types
class _notificationPageState extends State<notificationPage> {
  final List<Map4dMapExampleAppPage> _allPages = <Map4dMapExampleAppPage>[
    MarkerIconsPage(),
    PlacePOIPage(),
    PlaceBuildingPage(),
    // ignore: prefer_const_constructors
    DirectionsRendererPage(),
    PlaceCirclePage(),
    PlacePolylinePage(),
    PlacePolygonPage(),
    TileOverlayPage(),
    ImageOverlayPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _allPages.length,
        itemBuilder: (BuildContext context, int i) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: ListTile(
              leading: _allPages[i].leading,
              title: Text(_allPages[i].title),
              onTap: () {
                _pushPage(context, _allPages[i]);
              },
            ),
          );
        },
      ),
    );
  }

  void _pushPage(BuildContext context, Map4dMapExampleAppPage page) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
              appBar: AppBar(title: Text(page.title)),
              body: page,
            )));
  }
}
