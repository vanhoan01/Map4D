import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';

import 'page.dart';

//các đối tượng 3D mô phỏng lại các tòa nhà, cây cối, các cây cầu cũng như các công trình kiến trúc khác
class PlaceBuildingPage extends Map4dMapExampleAppPage {
  const PlaceBuildingPage({super.key})
      : super(const Icon(Icons.home_outlined), 'Place Building');

  @override
  Widget build(BuildContext context) {
    return const PlaceBuildingBody();
  }
}

class PlaceBuildingBody extends StatefulWidget {
  const PlaceBuildingBody({super.key});

  @override
  State<StatefulWidget> createState() => PlaceBuildingBodyState();
}

class PlaceBuildingBodyState extends State<PlaceBuildingBody> {
  PlaceBuildingBodyState();

  //Vị trí của building trên bản đồ
  // ignore: prefer_const_declarations
  static final MFLatLng _kInitPosition =
      const MFLatLng(12.205748339991535, 109.21646118164062);
  // ignore: prefer_const_declarations
  static final MFLatLng _kInitExtrudeBuildingPosition =
      const MFLatLng(12.204364143802083, 109.21652555465698);
  // ignore: prefer_const_declarations
  static final MFLatLng _kInitTextureBuildingPosition =
      const MFLatLng(12.206755023585973, 109.21641826629639);

  late MFMapViewController controller;
  //mảng các buildings
  Map<MFBuildingId, MFBuilding> buildings = <MFBuildingId, MFBuilding>{};
  //dùng tạo id
  int _buildingIdCounter = 1;
  MFBuildingId? selectedBuilding;
  MFBuildingId? _extrudeBuildingId;
  //kết cấu
  MFBuildingId? _textureBuildingId;

  void _onMapCreated(MFMapViewController controller) {
    this.controller = controller;
    // ignore: deprecated_member_use
    this.controller.enable3DMode(true);
  }

  //cập nhật building được chọn
  void _onBuildingTapped(MFBuildingId id) {
    // ignore: avoid_print
    print('Selected building: $id');
    setState(() {
      selectedBuilding = id;
    });
  }

  //xóa building, _extrudeBuilding nếu có. set _textureBuildingId = null hoặc _textureBuildingId = null và selectedBuilding = null
  void _remove(MFBuildingId id) {
    setState(() {
      if (buildings.containsKey(id)) {
        buildings.remove(id);
      }
      if (id == _extrudeBuildingId) {
        _extrudeBuildingId = null;
      } else if (id == _textureBuildingId) {
        _textureBuildingId = null;
      }
      if (id == selectedBuilding) {
        selectedBuilding = null;
      }
    });
  }

  //tự tạo: thêm extrude, hình khối màu trắng
  void _addExtrudeBuilding() {
    //tạo buildingId
    final String buildingIdVal = 'building_id_$_buildingIdCounter';
    _buildingIdCounter++;

    //Mảng các vị trí để tạo building hình khối với mặt đáy của hình khối là mảng vị trí này.
    final List<MFLatLng> coordinates = <MFLatLng>[
      const MFLatLng(12.204259280159668, 109.21635255217552),
      const MFLatLng(12.204259280159668, 109.2167267203331),
      const MFLatLng(12.20450177726977, 109.2167267203331),
      const MFLatLng(12.20450177726977, 109.21635255217552),
      const MFLatLng(12.204259280159668, 109.21635255217552)
    ];
    final MFBuildingId buildingId = MFBuildingId(buildingIdVal);
    //tạo building
    final MFBuilding building = MFBuilding(
      buildingId: buildingId,
      consumeTapEvents: true,
      //Vị trí của building trên bản đồ
      position: _kInitExtrudeBuildingPosition,
      name: 'Extrude Building',
      //mặt đáy
      coordinates: coordinates,
      height: 100,
      onTap: () {
        _onBuildingTapped(buildingId);
      },
    );

    _extrudeBuildingId = buildingId;
    setState(() {
      buildings[buildingId] = building;
    });
  }

  //load từ mạng: thêm kết cấu cho building
  void _addTextureBuilding() {
    final String buildingIdVal = 'building_id_$_buildingIdCounter';
    _buildingIdCounter++;
    final MFBuildingId buildingId = MFBuildingId(buildingIdVal);

    final MFBuilding building = MFBuilding(
      buildingId: buildingId,
      consumeTapEvents: true,
      position: _kInitTextureBuildingPosition,
      name: 'Texture Building',
      modelUrl:
          'https://sw-hcm-1.vinadata.vn/v1/AUTH_d0ecabcbdcd74f6aa6ac9a5da528eb78/sdk/models/5b21d9a5cd18d02d045a5e99',
      textureUrl:
          'https://sw-hcm-1.vinadata.vn/v1/AUTH_d0ecabcbdcd74f6aa6ac9a5da528eb78/sdk/textures/0cb35e1610c34e55946a7839356d8f66.jpg',
      onTap: () {
        _onBuildingTapped(buildingId);
      },
    );

    _textureBuildingId = buildingId;
    setState(() {
      buildings[buildingId] = building;
    });
  }

  void _toggleVisible(MFBuildingId buildingId) {
    final MFBuilding building = buildings[buildingId]!;
    setState(() {
      buildings[buildingId] = building.copyWith(
        visibleParam: !building.visible,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final MFBuildingId? selectedId = selectedBuilding;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 350.0,
            height: 500.0,
            child: MFMapView(
              initialCameraPosition: MFCameraPosition(target: _kInitPosition),
              buildings: Set<MFBuilding>.of(buildings.values),
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
                          onPressed: (_textureBuildingId != null)
                              ? null
                              : () => _addTextureBuilding(),
                          child: const Text('Add Texture Building'),
                        ),
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _remove(selectedId),
                          child: const Text('Remove'),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        TextButton(
                          onPressed: (_extrudeBuildingId != null)
                              ? null
                              : () => _addExtrudeBuilding(),
                          child: const Text('Add Extrude Building'),
                        ),
                        TextButton(
                          onPressed: (selectedId == null)
                              ? null
                              : () => _toggleVisible(selectedId),
                          child: const Text('Toggle Visible'),
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
