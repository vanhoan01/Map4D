// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';
import 'dart:math';
import 'page.dart';

//Marker dùng để xác định một vị trí trên bản đồ, cho phép người dùng thêm một điểm ghim ở một vị trí xác định.
class MarkerIconsPage extends Map4dMapExampleAppPage {
  const MarkerIconsPage({super.key})
      : super(const Icon(Icons.add_location_sharp), 'Place Marker');

  @override
  Widget build(BuildContext context) {
    return const PlaceMarkerBody();
  }
}

class PlaceMarkerBody extends StatefulWidget {
  const PlaceMarkerBody({super.key});

  @override
  State<PlaceMarkerBody> createState() => _PlaceMarkerBodyState();
}

class _PlaceMarkerBodyState extends State<PlaceMarkerBody> {
  //Khởi tạo
  _PlaceMarkerBodyState() {
    const MFMarkerId markerId = MFMarkerId('marker_id_0');
    final MFMarker marker = MFMarker(
      //Cho phép người dùng có thể tương tác được với Marker
      consumeTapEvents: true,
      //Id của Marker
      markerId: markerId,
      //Vị trí của Marker trên bản đồ
      position: const MFLatLng(16.0324816, 108.132794),
      //Xác định điểm neo cho Marker.
      anchor: const Offset(0.5, 1.0),
      //Tùy chỉnh thông tin hiển thị khi người dùng tap vào marker.
      infoWindow: MFInfoWindow(
          snippet: "Snippet",
          title: "Map4D",
          //Xác định điểm neo cho Marker.
          anchor: const Offset(0.5, 0.0),
          onTap: () {
            _onInfoWindowTapped(markerId);
          }),
      //Chỉ định thứ tự hiển thị giữa marker với các đối tượng khác trên bản đồ
      zIndex: 1.0,
      //Callback được gọi khi người dùng tap vào marker.
      onTap: () {
        _onMarkerTapped(markerId);
      },
      //Callback được gọi khi người dùng kết thúc việc kéo marker trên bản đồ.
      onDragEnd: (MFLatLng position) {
        _onMarkerDragEnd(markerId, position);
      },
    );
    markers[markerId] = marker;
  }

  MFMapViewController? controller;
  // icon của marker
  MFBitmap? _markerIcon;
  //Mảng các marker
  Map<MFMarkerId, MFMarker> markers = <MFMarkerId, MFMarker>{};
  //bộ đếm markerId
  int _markerIdCounter = 1;
  int _indexPosition = 0;
  MFMarkerId? selectedMarker; //Marker được chọn
  int currentZIndex = 0; // thứ tự hiển thị giữa marker
  // mảng thứ tự hiển thị giữa marker
  List<double> zIndexs = <double>[
    0.0,
    10.0,
  ];

  int currentRotation = 0; //góc quay của Marker hiện tại
  //mảng các góc quay của Marker
  List<double> rotations = <double>[
    0.0,
    30.0,
    60.0,
    90.0,
    120.0,
    150.0,
    180.0,
    210.0,
    240.0,
    270.0,
    300.0,
    330.0,
    360.0
  ];

  //Độ cao hiện tại
  int currentElevation = 0;
  //Mảng Độ cao
  List<double> elevations = <double>[0.0, 100.0, 200.0, 1000.0];

  //Giá trị khi chuyển đổi chiều rộng nét tròn
  int widthsIndex = 0;
  List<int> widths = <int>[10, 20, 5];

  //tạo map
  void _onMapCreated(MFMapViewController controller) {
    this.controller = controller;
  }

  //được gọi khi đối tượng State bị xóa vĩnh viễn
  @override
  void dispose() {
    super.dispose();
  }

  //in thông tin marker được tap
  void _onInfoWindowTapped(MFMarkerId markerId) {
    // ignore: prefer_interpolation_to_compose_strings
    print("Did tap info window of " + markerId.value);
  }

  //set marker được tap
  void _onMarkerTapped(MFMarkerId markerId) {
    setState(() {
      selectedMarker = markerId;
    });
  }

  //kéo marker
  void _onMarkerDragEnd(MFMarkerId markerId, MFLatLng newPosition) async {
    final MFMarker? tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              )
            ],
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 66),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Old position: ${tappedMarker.position}'),
                  Text('New position: $newPosition'),
                ],
              ),
            ),
          );
        },
      );
    }
    final MFMarker marker = markers[markerId]!;
    setState(() {
      markers[markerId] = marker.copyWith(positionParam: newPosition);
    });
  }

  //xóa marker
  void _remove(MFMarkerId markerId) {
    setState(() {
      if (markers.containsKey(markerId)) {
        markers.remove(markerId);
      }
      if (markerId == selectedMarker) {
        selectedMarker = null;
      }
    });
  }

  //thêm marker
  void _add() {
    final int markerCount = markers.length;

    //tối đa 13 marker
    if (markerCount == 13) {
      return;
    }

    //giá trị marker id
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    //đếm markerid thêm 1
    _markerIdCounter++;
    //khởi tạo marker id
    final MFMarkerId markerId = MFMarkerId(markerIdVal);

    //khởi tạo marker
    final MFMarker marker = MFMarker(
      consumeTapEvents: true,
      markerId: markerId,
      position: _createCenter(),
      icon: _markerIcon!,
      infoWindow: MFInfoWindow(
          snippet: "Snippet",
          title: "Map4D",
          anchor: const Offset(0.5, 0.0),
          onTap: () {
            _onInfoWindowTapped(markerId);
          }),
      zIndex: 1.0,
      onTap: () {
        _onMarkerTapped(markerId);
      },
      onDragEnd: (MFLatLng position) {
        _onMarkerDragEnd(markerId, position);
      },
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  //thay đổi vị trí
  void _changePostion(MFMarkerId markerId) {
    //giá trị thay đổi vị trí < 8
    if (_indexPosition >= 8) {
      _indexPosition = 0;
    }

    //marker được chọn
    final MFMarker marker = markers[markerId]!;
    //coppy và thay thế thay đổi vị trí
    setState(() {
      markers[markerId] = marker.copyWith(
        positionParam: MFLatLng(
            16.0324816 + sin(_indexPosition * pi / 4.0) / 6.0 * 0.8,
            108.132791 + cos(_indexPosition * pi / 4.0) / 6.0),
      );
      _indexPosition += 1;
    });
  }

  //thay đổi info
  Future<void> _changeInfo(MFMarkerId markerId) async {
    //marker được chọn
    final MFMarker marker = markers[markerId]!;
    //new info
    final String newSnippet = '${marker.infoWindow.snippet!}*****';
    //coppy và thay thế thay đổi
    setState(() {
      markers[markerId] = marker.copyWith(
        infoWindowParam: marker.infoWindow.copyWith(
          snippetParam: newSnippet,
        ),
      );
    });
  }

  //hàm thay đổi góc
  void _changeRotation(MFMarkerId markerId) {
    //marker được chọn
    final MFMarker marker = markers[markerId]!;
    //coppy và thay thế thay đổi góc
    setState(() {
      markers[markerId] = marker.copyWith(
        rotationParam: rotations[++currentRotation % rotations.length],
      );
    });
  }

  //hàm thay đổi độ cao
  void _changeElevation(MFMarkerId markerId) {
    //marker được chọn
    final MFMarker marker = markers[markerId]!;
    //coppy và thay thế thay đổi độ cao
    setState(() {
      markers[markerId] = marker.copyWith(
        elevationParam: elevations[++currentElevation % elevations.length],
      );
    });
  }

  //hàm thay đổi kéo
  void _changeDraggable(MFMarkerId markerId) {
    final MFMarker marker = markers[markerId]!;
    setState(() {
      markers[markerId] = marker.copyWith(
        draggableParam: !marker.draggable,
      );
    });
  }

  //thay đổi ẩn hiện
  void _changeVisible(MFMarkerId markerId) {
    final MFMarker marker = markers[markerId]!;
    setState(() {
      markers[markerId] = marker.copyWith(
        visibleParam: !marker.visible,
      );
    });
  }

  //thay đổi thứ tự hiển thị
  void _changeZindex(MFMarkerId markerId) {
    final MFMarker marker = markers[markerId]!;
    setState(() {
      markers[markerId] = marker.copyWith(
        zIndexParam: zIndexs[++currentZIndex % zIndexs.length],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset(context);
    final MFMarkerId? selectedId = selectedMarker;
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
                target: MFLatLng(16.0324816, 108.132791),
                zoom: 10.0,
              ),
              markers: Set<MFMarker>.of(markers.values),
              onMapCreated: _onMapCreated,
            ),
          ),
        ),
        // FloatingActionButton(
        //   child: const Icon(Icons.my_location),
        //   onPressed: () {
        //     getUserLocation();
        //     controller!.moveCamera(MFCameraUpdate.newLatLng(_kLandmark81!));
        //     print("hhhhhh");
        //   },
        // ),
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
                                : () => _changeInfo(selectedId),
                            child: const Text('change info')),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changePostion(selectedId),
                          child: const Text('change position'),
                        ),
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeElevation(selectedId),
                          child: const Text('change elevation'),
                        ),
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeRotation(selectedId),
                          child: const Text('change rotation'),
                        ),
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeDraggable(selectedId),
                          child: const Text('change draggable'),
                        ),
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeVisible(selectedId),
                          child: const Text('change visible'),
                        ),
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeZindex(selectedId),
                          child: const Text('change zIndex'),
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

  void getUserLocation() async {
    setState(() {});
  }

  MFLatLng _createCenter() {
    return _createLatLng(
        16.0324816 + sin(_markerIdCounter * pi / 6.0) / 10.0 * 0.8,
        108.132791 + cos(_markerIdCounter * pi / 6.0) / 10.0);
  }

  MFLatLng _createLatLng(double lat, double lng) {
    return MFLatLng(lat, lng);
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size.square(48));
      _markerIcon = await MFBitmap.fromAssetImage(
          imageConfiguration, 'assets/ic_marker_tracking.png');
    }
  }
}
