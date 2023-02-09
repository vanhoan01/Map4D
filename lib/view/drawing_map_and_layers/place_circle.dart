import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';

import 'page.dart';

class PlaceCirclePage extends Map4dMapExampleAppPage {
  const PlaceCirclePage({super.key})
      : super(const Icon(Icons.animation), 'Place circle');

  @override
  Widget build(BuildContext context) {
    return const PlaceCircleBody();
  }
}

class PlaceCircleBody extends StatefulWidget {
  const PlaceCircleBody({super.key});

  @override
  State<StatefulWidget> createState() => PlaceCircleBodyState();
}

class PlaceCircleBodyState extends State<PlaceCircleBody> {
  //khởi tạo: khởi tạo một circle
  PlaceCircleBodyState() {
    const MFCircleId circleId = MFCircleId('circle_id_0');
    final MFCircle circle = MFCircle(
        circleId: circleId,
        consumeTapEvents: true,
        strokeColor: Colors.orange,
        fillColor: Colors.green,
        strokeWidth: 5,
        center: const MFLatLng(51.4816, -3.1791),
        //Bán kính đường của tròn tính từ tâm
        radius: 50000,
        onTap: () {
          _onCircleTapped(circleId);
        });
    circles[circleId] = circle;
  }

  MFMapViewController? controller;
  //mảng circles
  Map<MFCircleId, MFCircle> circles = <MFCircleId, MFCircle>{};
  //đếm làm id circle
  int _circleIdCounter = 1;
  //circle đang được chọn
  MFCircleId? selectedCircle;

  // Values when toggling circle color
  //số để thay đổi random
  int fillColorsIndex = 0;
  int strokeColorsIndex = 0;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];

  // Values when toggling circle stroke width
  int widthsIndex = 0;
  List<int> widths = <int>[10, 20, 5];

  void _onMapCreated(MFMapViewController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onCircleTapped(MFCircleId circleId) {
    //set tap circle: set selectedCircle khi tap vào
    setState(() {
      selectedCircle = circleId;
    });
  }

  void _remove(MFCircleId circleId) {
    //xóa circle nếu id có. và set selectCircle = null
    setState(() {
      if (circles.containsKey(circleId)) {
        circles.remove(circleId);
      }
      if (circleId == selectedCircle) {
        selectedCircle = null;
      }
    });
  }

  void _add() {
    //kiểm tra tối đa circle là 12
    final int circleCount = circles.length;

    if (circleCount == 12) {
      return;
    }

    //tạo circleId
    final String circleIdVal = 'circle_id_$_circleIdCounter';
    _circleIdCounter++;
    final MFCircleId circleId = MFCircleId(circleIdVal);

    //Tạo circle
    final MFCircle circle = MFCircle(
      circleId: circleId,
      consumeTapEvents: true,
      strokeColor: Colors.orange,
      fillColor: Colors.green,
      strokeWidth: 5,
      //Chỉ định vị trí của Circle trên bản đồ
      center: _createCenter(),
      //Bán kính đường của tròn tính từ tâm
      radius: 50000,
      //set tap: set select circleId
      onTap: () {
        _onCircleTapped(circleId);
      },
    );

    //thêm
    setState(() {
      circles[circleId] = circle;
    });
  }

  void _toggleVisible(MFCircleId circleId) {
    final MFCircle circle = circles[circleId]!;
    setState(() {
      circles[circleId] = circle.copyWith(
        visibleParam: !circle.visible,
      );
    });
  }

  void _changeFillColor(MFCircleId circleId) {
    //random theo fillColorsIndex
    final MFCircle circle = circles[circleId]!;
    setState(() {
      circles[circleId] = circle.copyWith(
        fillColorParam: colors[++fillColorsIndex % colors.length],
      );
    });
  }

  void _changeStrokeColor(MFCircleId circleId) {
    final MFCircle circle = circles[circleId]!;
    setState(() {
      circles[circleId] = circle.copyWith(
        strokeColorParam: colors[++strokeColorsIndex % colors.length],
      );
    });
  }

  void _changeStrokeWidth(MFCircleId circleId) {
    final MFCircle circle = circles[circleId]!;
    setState(() {
      circles[circleId] = circle.copyWith(
        strokeWidthParam: widths[++widthsIndex % widths.length],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final MFCircleId? selectedId = selectedCircle;
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
                target: MFLatLng(52.4478, -3.5402),
                zoom: 7.0,
              ),
              //set mảng circles
              circles: Set<MFCircle>.of(circles.values),
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
                        //Thay đổi độ lớn đường viền của Circle
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeStrokeWidth(selectedId),
                          child: const Text('change stroke width'),
                        ),
                        //Thay đổi màu sắc đường viền của Circle
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeStrokeColor(selectedId),
                          child: const Text('change stroke color'),
                        ),
                        //Thay đổi màu sắc của Circle.
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

  //Chỉ định vị trí của Circle trên bản đồ. random theo _circleIdCounter
  MFLatLng _createCenter() {
    final double offset = _circleIdCounter.ceilToDouble();
    return _createLatLng(51.4816 + offset * 0.2, -3.1791);
  }

  MFLatLng _createLatLng(double lat, double lng) {
    return MFLatLng(lat, lng);
  }
}
