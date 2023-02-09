import 'dart:math';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:map4d_map/map4d_map.dart';

import 'page.dart';

//Các đối tượng POI bạn thêm vào bản đồ có thể hiện thị ở cả 2 chế độ 2D và 3D.
class PlacePOIPage extends Map4dMapExampleAppPage {
  const PlacePOIPage({super.key}) : super(const Icon(Icons.room), 'Place POI');

  @override
  Widget build(BuildContext context) {
    return const PlacePOIBody();
  }
}

class PlacePOIBody extends StatefulWidget {
  const PlacePOIBody({super.key});

  @override
  State<StatefulWidget> createState() => PlacePOIBodyState();
}

class PlacePOIBodyState extends State<PlacePOIBody> {
  //hàm khởi tạo
  PlacePOIBodyState();

  MFMapViewController? controller;
  //icon marker
  MFBitmap? _markerIcon;
  //mảng poi
  Map<MFPOIId, MFPOI> pois = <MFPOIId, MFPOI>{};
  //đếm poi
  int _poiIdCounter = 1;
  //poi được chọn
  MFPOIId? selectedPOI;

  void _onMapCreated(MFMapViewController controller) {
    this.controller = controller;
  }

  //tap điểm bất kì trên map
  void _onTap(MFLatLng coordinate) {
    //add(vị trí) [phía trong có _onPOITapped]
    _add(coordinate);
  }

  //tap lên poi: set selectedPOI trong sự kiện tap
  void _onPOITapped(MFPOIId poiId) {
    setState(() {
      selectedPOI = poiId;
    });
  }

  void _remove(MFPOIId poiId) {
    setState(() {
      if (pois.containsKey(poiId)) {
        pois.remove(poiId);
      }
      if (poiId == selectedPOI) {
        selectedPOI = null;
      }
    });
  }

  void _add(MFLatLng position) {
    //tăng đếm poi
    final String poiIdVal = 'poi_id_$_poiIdCounter';
    _poiIdCounter++;
    //tạo poi id
    final MFPOIId poiId = MFPOIId(poiIdVal);

    final MFPOI poi = MFPOI(
      poiId: poiId,
      //Cho phép người dùng có thể tương tác được với POI
      consumeTapEvents: true,
      //Vị trí của POI trên bản đồ
      position: position,
      title: WordPair.random().asPascalCase,
      titleColor: _randomColor(null),
      // subtitle: WordPair.random().asLowerCase,
      // icon: _markerIcon!,
      //atm, park, cafe, ...
      type: _randomType(null),
      //Callback được gọi khi người dùng tap vào POI.
      //set select poin hiện tại
      onTap: () {
        _onPOITapped(poiId);
      },
    );

    //thêm vào mảng
    setState(() {
      pois[poiId] = poi;
    });
  }

  void _toggleVisible(MFPOIId poiId) {
    final MFPOI poi = pois[poiId]!;
    //Tạo một bản sao của chủ đề này nhưng với các trường đã cho được thay thế bằng các giá trị mới.
    setState(() {
      pois[poiId] = poi.copyWith(
        visibleParam: !poi.visible,
      );
    });
  }

  void _changeTitle(MFPOIId poiId) {
    final MFPOI poi = pois[poiId]!;
    setState(() {
      pois[poiId] = poi.copyWith(
        titleParam: WordPair.random().asPascalCase,
      );
    });
  }

  void _changeTitleColor(MFPOIId poiId) {
    final MFPOI poi = pois[poiId]!;
    final Color color = _randomColor(poi.titleColor);
    setState(() {
      pois[poiId] = poi.copyWith(titleColorParam: color);
    });
  }

  Color _randomColor(Color? ignore) {
    final List<Color> colors = <Color>[
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.black
    ];
    //xóa màu đang dùng
    if (ignore != null) {
      colors.remove(ignore);
    }
    //random
    final random = Random();
    return colors[random.nextInt(colors.length)];
  }

  String _randomType(String? ignore) {
    final List<String> types = <String>[
      'government',
      'museum',
      'motel',
      'bank',
      'supermarket',
      'restaurant',
      'cafe',
      'school',
      'stadium',
      'pharmacy',
      'university',
      'police',
      'bar',
      'atm',
      'hospital',
      'park'
    ];
    //xóa type đang dùng
    if (ignore != null) {
      types.remove(ignore);
    }
    final random = Random();
    return types[random.nextInt(types.length)];
  }

  //icon image marker
  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size.square(48));
      _markerIcon = await MFBitmap.fromAssetImage(
          imageConfiguration, 'assets/ic_marker_tracking.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset(context);
    final MFPOIId? selectedId = selectedPOI;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 350.0,
            height: 300.0,
            child: MFMapView(
              //set mảng poi
              pois: Set<MFPOI>.of(pois.values),
              onMapCreated: _onMapCreated,
              onTap: _onTap,
            ),
          ),
        ),
        //chiếm phần không gian còn lại
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        //xóa
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _remove(selectedId),
                          child: const Text('remove'),
                        ),
                        //chuyển đổi Hiển thị
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
                              : () => _changeTitle(selectedId),
                          child: const Text('change title'),
                        ),
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeTitleColor(selectedId),
                          child: const Text('change title color'),
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
}
