import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';

import 'page.dart';

//Để vẽ các đường thẳng trên bản đồ
class PlacePolylinePage extends Map4dMapExampleAppPage {
  const PlacePolylinePage({super.key})
      : super(const Icon(Icons.line_weight), 'Place polyline');

  @override
  Widget build(BuildContext context) {
    return const PlacePolylineBody();
  }
}

class PlacePolylineBody extends StatefulWidget {
  const PlacePolylineBody({super.key});

  @override
  State<StatefulWidget> createState() => PlacePolylineBodyState();
}

class PlacePolylineBodyState extends State<PlacePolylineBody> {
  PlacePolylineBodyState() {
    //id line
    const MFPolylineId polylineId = MFPolylineId('polyline_id_0');
    //Mảng các tọa độ để tạo polyline
    List<MFLatLng> points = <MFLatLng>[
      const MFLatLng(52.30176096373671, -5.767822265625),
      const MFLatLng(50.93073802371819, -4.954833984374999),
      const MFLatLng(52.1267438596429, -1.8896484375),
      const MFLatLng(53.35710874569601, -5.33935546875),
      const MFLatLng(54.59752785211386, -2.252197265625)
    ];
    //khởi tạo line
    final MFPolyline polyline = MFPolyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.yellow,
      width: 5,
      //Mảng các tọa độ để tạo polyline
      points: points,
      onTap: () {
        _onPolylineTapped(polylineId);
      },
    );
    //thêm vào mảng polylines
    polylines[polylineId] = polyline;
  }

  MFMapViewController? controller;
  //mảng các line
  Map<MFPolylineId, MFPolyline> polylines = <MFPolylineId, MFPolyline>{};
  //dùng xác định id line
  int _polylineIdCounter = 1;
  //line đang chọn
  MFPolylineId? selectedPolyline;

  // Values when toggling polyline color
  //dùng xác định color
  int colorsIndex = 0;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];

  // Values when toggling polyline width
  //dùng độ rộng của polyline theo đơn vị point
  int widthsIndex = 0;
  List<int> widths = <int>[10, 20, 5];

  //Nét vẽ cho polyline (solid hoặc dotted)
  int polylineStyleIndex = 0;
  List<MFPolylineStyle> polylineStyles = <MFPolylineStyle>[
    MFPolylineStyle.solid,
    MFPolylineStyle.dotted,
  ];

  void _onMapCreated(MFMapViewController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  //tap lên line -> update selectedPolyline hiện tại
  void _onPolylineTapped(MFPolylineId polylineId) {
    setState(() {
      selectedPolyline = polylineId;
    });
  }

  void _remove(MFPolylineId polylineId) {
    //xóa line nếu tồn tại. và set selectedPolyline = null
    setState(() {
      if (polylines.containsKey(polylineId)) {
        polylines.remove(polylineId);
      }
      selectedPolyline = null;
    });
  }

  void _add() {
    //giới hạn 12 line
    final int polylineCount = polylines.length;

    if (polylineCount == 12) {
      return;
    }

    //xác định id olyline dựa vào _polylineIdCounter
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final MFPolylineId polylineId = MFPolylineId(polylineIdVal);

    //khởi tạo olyline mới
    final MFPolyline polyline = MFPolyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.orange,
      width: 5,
      //tạo Mảng các tọa độ để tạo polyline
      points: _createPoints(),
      //sự kiện tap: set id polyline đang chọn
      onTap: () {
        _onPolylineTapped(polylineId);
      },
    );

    //thêm vào mảng polylines
    setState(() {
      polylines[polylineId] = polyline;
    });
  }

  void _toggleVisible(MFPolylineId polylineId) {
    final MFPolyline polyline = polylines[polylineId]!;
    setState(() {
      polylines[polylineId] = polyline.copyWith(
        visibleParam: !polyline.visible,
      );
    });
  }

  void _changeColor(MFPolylineId polylineId) {
    final MFPolyline polyline = polylines[polylineId]!;
    setState(() {
      polylines[polylineId] = polyline.copyWith(
        //lấy colors[chia dư -> luôn < colors.length]
        colorParam: colors[++colorsIndex % colors.length],
      );
    });
  }

  void _changeWidth(MFPolylineId polylineId) {
    final MFPolyline polyline = polylines[polylineId]!;
    setState(() {
      polylines[polylineId] = polyline.copyWith(
        widthParam: widths[++widthsIndex % widths.length],
      );
    });
  }

  void _changeStyle(MFPolylineId polylineId) {
    final MFPolyline polyline = polylines[polylineId]!;
    setState(() {
      polylines[polylineId] = polyline.copyWith(
        styleParam:
            polylineStyles[++polylineStyleIndex % polylineStyles.length],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final MFPolylineId? selectedId = selectedPolyline;

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
                target: MFLatLng(53.1721, -3.5402),
                zoom: 5.0,
              ),
              //set mảng polylines
              polylines: Set<MFPolyline>.of(polylines.values),
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
                              : () => _changeWidth(selectedId),
                          child: const Text('change width'),
                        ),
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeColor(selectedId),
                          child: const Text('change color'),
                        ),
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeStyle(selectedId),
                          child: const Text('change style'),
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

  //tạo Mảng các tọa độ để tạo polyline
  List<MFLatLng> _createPoints() {
    final List<MFLatLng> points = <MFLatLng>[];
    //thay đổi theo _polylineIdCounter
    final double offset = _polylineIdCounter.ceilToDouble();
    points.add(_createLatLng(51.4816 + offset, -3.1791));
    points.add(_createLatLng(53.0430 + offset, -2.9925));
    points.add(_createLatLng(53.1396 + offset, -4.2739));
    points.add(_createLatLng(52.4153 + offset, -4.0829));
    return points;
  }

  //tạo một tọa độ dựa vào x, y
  MFLatLng _createLatLng(double lat, double lng) {
    return MFLatLng(lat, lng);
  }
}
