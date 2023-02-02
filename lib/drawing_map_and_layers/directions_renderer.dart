import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';
import 'page.dart';

class DirectionsRendererPage extends Map4dMapExampleAppPage {
  const DirectionsRendererPage({super.key})
      : super(const Icon(Icons.account_tree), 'Directions Renderer');

  @override
  Widget build(BuildContext context) {
    return const DirectionsRendererBody();
  }
}

class DirectionsRendererBody extends StatefulWidget {
  const DirectionsRendererBody({super.key});

  @override
  State<StatefulWidget> createState() => DirectionsRendererBodyState();
}

class DirectionsRendererBodyState extends State<DirectionsRendererBody> {
  MFDirectionsRenderer? _directionsRenderer; //Trình kết xuất chỉ đường
  MFBitmap? _originIcon; //điểm bắt đầu
  MFBitmap? _destinationIcon; //điểm kết thúc

  //Khởi tạo DirectionsRendererBodyState
  DirectionsRendererBodyState() {
    //khởi tạo id chỉ đường
    // ignore: prefer_const_declarations
    final MFDirectionsRendererId rendererId =
        const MFDirectionsRendererId('renderer_id_0');

    //khởi tạo đối tượng
    _directionsRenderer = MFDirectionsRenderer(
        rendererId: rendererId,
        routes: _createRoutes(),
        activedIndex: 1,
        originPOIOptions: const MFDirectionsPOIOptions(visible: false),
        destinationPOIOptions: const MFDirectionsPOIOptions(visible: false),
        onRouteTap: _onTapped);
  }

  //khởi tạo icon các điểm
  Future<void> _createIconFromAsset(BuildContext context) async {
    if (_originIcon == null && _destinationIcon == null) {
      //khởi tạo icon config
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      _originIcon = await MFBitmap.fromAssetImage(
          imageConfiguration, 'assets/map-marker-1.png');
      _destinationIcon = await MFBitmap.fromAssetImage(
          imageConfiguration, 'assets/map-marker-2.png');
    }
  }

  //tạo mapview
  void _onMapCreated(MFMapViewController controller) {}

  //trả về route của tuyến đường được chọn
  void _onTapped(int routeIndex) {
    setState(() {
      _directionsRenderer = _directionsRenderer!.copyWith(
        //Chỉ mục chính của tuyến đường trong routes hoặc directions
        activedIndexParam: routeIndex,
      );
    });
  }

  //thêm trình kết xuất chỉ đường
  void _add() {
    if (_directionsRenderer != null) {
      return;
    }

    final MFDirectionsRendererId rendererId =
        // ignore: prefer_const_constructors
        MFDirectionsRendererId('renderer_id_1');
    MFDirectionsRenderer renderer = MFDirectionsRenderer(
      rendererId: rendererId,
      //Mảng các mảng tọa độ thể hiện chỉ đường sẽ được hiển thị lên bản đồ
      routes: _createRoutes(),
      activedIndex: 1,
      //Kích thước của tuyến đường chính (activedIndex)
      activeStrokeWidth: 12,
      //Màu của tuyến đường chính
      activeStrokeColor: Colors.yellow,
      //Kích thước outline của tuyến đường chính
      activeOutlineWidth: 4,
      //Màu outline của tuyến đường chính
      activeOutlineColor: Colors.yellow.shade900,
      //Kích thước các tuyến đường phụ
      inactiveStrokeWidth: 10,
      //Màu của các tuyến đường phụ
      inactiveStrokeColor: Colors.brown,
      //Kích thước outline của các tuyến đường phụ
      inactiveOutlineWidth: 4,
      //Màu outline của các tuyến đường phụ
      inactiveOutlineColor: Colors.brown.shade900,
      //Các giá trị tùy chọn hiển thị cho POI đánh dấu vị trí bắt đầu
      originPOIOptions: MFDirectionsPOIOptions(
        position: MFLatLng(16.079774, 108.220534),
        icon: _originIcon,
        title: 'Begin',
        titleColor: Colors.red,
      ),
      //Các giá trị tùy chọn hiển thị cho POI đánh dấu vị trí kết thúc.
      destinationPOIOptions: MFDirectionsPOIOptions(
        position: MFLatLng(16.073885, 108.224184),
        icon: _destinationIcon,
        title: 'End',
        titleColor: Colors.green,
      ),
      //trả về route của tuyến đường được chọn
      onRouteTap: (int routeIndex) => _onTapped(routeIndex),
    );

    //thêm
    setState(() {
      _directionsRenderer = renderer;
    });
  }

  void _remove() {
    if (_directionsRenderer == null) {
      return;
    }

    //xóa
    setState(() {
      _directionsRenderer = null;
    });
  }

  //được gọi khi đối tượng State bị xóa vĩnh viễn
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //tạo và hiển thị icon điểm đầu, điểm cuối
    _createIconFromAsset(context);
    Set<MFDirectionsRenderer> renderers = <MFDirectionsRenderer>{
      if (_directionsRenderer != null) _directionsRenderer!
    };
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            height: 500.0,
            child: MFMapView(
              initialCameraPosition: const MFCameraPosition(
                //điểm camera
                target: MFLatLng(16.077491, 108.221735),
                zoom: 16.0,
              ),
              directionsRenderers: renderers,
              onMapCreated: _onMapCreated,
            ),
          ),
        ),
        //button thêm chỉ đường
        TextButton(
          child: const Text('Add Directions Renderer'),
          onPressed: _directionsRenderer != null ? null : () => _add(),
        ),
        //button xóa chỉ đường
        TextButton(
          child: const Text('Remove Directions Renderer'),
          onPressed: _directionsRenderer == null ? null : () => _remove(),
        ),
      ],
    );
  }

  //Mảng các mảng tọa độ thể hiện chỉ đường sẽ được hiển thị lên bản đồ
  List<List<MFLatLng>> _createRoutes() {
    final List<MFLatLng> route0 = <MFLatLng>[];
    route0.add(MFLatLng(16.078814, 108.221592));
    route0.add(MFLatLng(16.078972, 108.223034));
    route0.add(MFLatLng(16.075353, 108.223513));

    final List<MFLatLng> route1 = <MFLatLng>[];
    route1.add(MFLatLng(16.078814, 108.221592));
    route1.add(MFLatLng(16.077491, 108.221735));
    route1.add(MFLatLng(16.077659, 108.223212));
    route1.add(MFLatLng(16.075353, 108.223513));

    final List<List<MFLatLng>> routes = <List<MFLatLng>>[];
    routes.add(route0);
    routes.add(route1);

    return routes;
  }
}
