import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';

import 'page.dart';

//Để vẽ các đa giác trên bản đồ
class PlacePolygonPage extends Map4dMapExampleAppPage {
  const PlacePolygonPage({super.key})
      : super(const Icon(Icons.auto_awesome_mosaic_sharp), 'Place polygon');

  @override
  Widget build(BuildContext context) {
    return const PlacePolygonBody();
  }
}

class PlacePolygonBody extends StatefulWidget {
  const PlacePolygonBody({super.key});

  @override
  State<StatefulWidget> createState() => PlacePolygonBodyState();
}

class PlacePolygonBodyState extends State<PlacePolygonBody> {
  //khởi tạo: khởi tạo polygon
  PlacePolygonBodyState() {
    const MFPolygonId polygonId = MFPolygonId('polygon_id_0');
    final MFPolygon polygon = MFPolygon(
      polygonId: polygonId,
      consumeTapEvents: true,
      strokeColor: Colors.orange,
      strokeWidth: 5,
      fillColor: Colors.green,
      points: _createPoints(),
      onTap: () {
        _onPolygonTapped(polygonId);
      },
    );
    //thêm vào mảng polygonOffsets một _polygonIdCounter
    polygonOffsets[polygonId] = _polygonIdCounter.ceilToDouble();
    //thêm vào mảng polygons một polygon
    polygons[polygonId] = polygon;
  }

  MFMapViewController? controller;
  Map<MFPolygonId, MFPolygon> polygons = <MFPolygonId, MFPolygon>{};
  //để tạo hố hole
  Map<MFPolygonId, double> polygonOffsets = <MFPolygonId, double>{};
  //xác định id
  int _polygonIdCounter = 1;
  //Polygon đang chọn
  MFPolygonId? selectedPolygon;

  // Values when toggling polygon color
  int strokeColorsIndex = 0;
  int fillColorsIndex = 0;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];

  // Values when toggling polygon width
  int widthsIndex = 0;
  List<int> widths = <int>[10, 20, 5];

  void _onMapCreated(MFMapViewController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  //set tap polygon: cập nhật selectedPolygon đang chọn
  void _onPolygonTapped(MFPolygonId polygonId) {
    setState(() {
      selectedPolygon = polygonId;
      // ignore: prefer_interpolation_to_compose_strings, avoid_print
      print("selected polygon: " + polygonId.toString());
    });
  }

  //xóa nếu có. và selectedPolygon = null
  void _remove(MFPolygonId polygonId) {
    setState(() {
      if (polygons.containsKey(polygonId)) {
        polygons.remove(polygonId);
      }
      selectedPolygon = null;
    });
  }

  //add:
  // + giới hạn số lượng polygon
  // + tạo polygon id
  // + tạo polygon
  // + thêm vào mảng polygons và polygonOffsets
  void _add() {
    final int polygonCount = polygons.length;

    if (polygonCount == 12) {
      return;
    }

    final String polygonIdVal = 'polygon_id_$_polygonIdCounter';
    _polygonIdCounter++;
    final MFPolygonId polygonId = MFPolygonId(polygonIdVal);

    final MFPolygon polygon = MFPolygon(
      polygonId: polygonId,
      consumeTapEvents: true,
      strokeColor: Colors.orange,
      strokeWidth: 5,
      fillColor: Colors.green,
      //Mảng các tọa độ để tạo polygon
      points: _createPoints(),
      onTap: () {
        _onPolygonTapped(polygonId);
      },
    );

    setState(() {
      polygonOffsets[polygonId] = _polygonIdCounter.ceilToDouble();
      polygons[polygonId] = polygon;
    });
  }

  //lấy polygon từ id, coppy and update visible
  void _toggleVisible(MFPolygonId polygonId) {
    final MFPolygon polygon = polygons[polygonId]!;
    setState(() {
      polygons[polygonId] = polygon.copyWith(
        visibleParam: !polygon.visible,
      );
    });
  }

  //Nhiều mảng các tọa độ để tạo holes cho polygon (tạo hố phía trong)
  void _addHoles(MFPolygonId polygonId) {
    final MFPolygon polygon = polygons[polygonId]!;
    setState(() {
      var holes = _createHoles(polygonId);
      polygons[polygonId] = polygon.copyWith(holesParam: holes);
    });
  }

  //holesParam = rỗng
  void _removeHoles(MFPolygonId polygonId) {
    final MFPolygon polygon = polygons[polygonId]!;
    setState(() {
      polygons[polygonId] = polygon.copyWith(
        holesParam: <List<MFLatLng>>[],
      );
    });
  }

  void _changeStokeColor(MFPolygonId polygonId) {
    final MFPolygon polygon = polygons[polygonId]!;
    setState(() {
      polygons[polygonId] = polygon.copyWith(
        strokeColorParam: colors[++strokeColorsIndex % colors.length],
      );
    });
  }

  void _changeStokeWidth(MFPolygonId polygonId) {
    final MFPolygon polygon = polygons[polygonId]!;
    setState(() {
      polygons[polygonId] = polygon.copyWith(
        strokeWidthParam: widths[++widthsIndex % widths.length],
      );
    });
  }

  void _changeFillColor(MFPolygonId polygonId) {
    final MFPolygon polygon = polygons[polygonId]!;
    setState(() {
      polygons[polygonId] = polygon.copyWith(
        fillColorParam: colors[++fillColorsIndex % colors.length],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final MFPolygonId? selectedId = selectedPolygon;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 350.0,
            height: 300.0,
            child: MFMapView(
              initialCameraPosition: const MFCameraPosition(
                target: MFLatLng(16.09628897915164, 108.09963226318358),
                zoom: 10.0,
              ),
              //Mảng các polygons
              polygons: Set<MFPolygon>.of(polygons.values),
              onMapCreated: _onMapCreated,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        TextButton(
                          onPressed: _add,
                          child: const Text('add'),
                        ),
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _remove(selectedId),
                          child: const Text('remove'),
                        ),
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _toggleVisible(selectedId),
                          child: const Text('toggle visible'),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _addHoles(selectedId),
                          child: const Text('add holes'),
                        ),
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _removeHoles(selectedId),
                          child: const Text('remove holes'),
                        ),
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeStokeColor(selectedId),
                          child: const Text('change stroke color'),
                        ),
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeStokeWidth(selectedId),
                          child: const Text('change stroke width'),
                        ),
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeFillColor(selectedId),
                          child: const Text('change fill color'),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  // /Mảng các tọa độ để tạo polygon
  List<MFLatLng> _createPoints() {
    final List<MFLatLng> points = <MFLatLng>[];
    final double offset = (_polygonIdCounter.ceilToDouble() - 1) / 4;
    points.add(_createLatLng(16.09628897915164 + offset, 108.09963226318358));
    points.add(_createLatLng(15.948785390273288 + offset, 108.08521270751953));
    points.add(_createLatLng(15.909828927635155 + offset, 108.22803497314453));
    points.add(_createLatLng(16.003245716502565 + offset, 108.31283569335938));
    points.add(_createLatLng(16.14510277154745 + offset, 108.20228576660156));
    points.add(_createLatLng(16.09628897915164 + offset, 108.09963226318358));
    return points;
  }

  //tạo hố phía trong
  List<List<MFLatLng>> _createHoles(MFPolygonId polygonId) {
    final List<List<MFLatLng>> holes = <List<MFLatLng>>[];
    //dựa vào _polygonIdCounter của polygonId
    final double offset = (polygonOffsets[polygonId]! - 1) / 4;

    final List<MFLatLng> hole1 = <MFLatLng>[];
    hole1.add(_createLatLng(16.102556286933407 + offset, 108.19370269775389));
    hole1.add(_createLatLng(16.058021127461473 + offset, 108.16280364990233));
    hole1.add(_createLatLng(16.05274222526572 + offset, 108.24897766113281));
    hole1.add(_createLatLng(16.102556286933407 + offset, 108.19370269775389));
    holes.add(hole1);

    final List<MFLatLng> hole2 = <MFLatLng>[];
    hole2.add(_createLatLng(16.055483506239545 + offset, 108.17070007324219));
    hole2.add(_createLatLng(16.00220588906289 + offset, 108.1710433959961));
    hole2.add(_createLatLng(16.008525929134183 + offset, 108.20022583007812));
    hole2.add(_createLatLng(16.043173858350652 + offset, 108.19267272949219));
    hole2.add(_createLatLng(16.055483506239545 + offset, 108.17070007324219));
    holes.add(hole2);

    return holes;
  }

  MFLatLng _createLatLng(double lat, double lng) {
    return MFLatLng(lat, lng);
  }
}
