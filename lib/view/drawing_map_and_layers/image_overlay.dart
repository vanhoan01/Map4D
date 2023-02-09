import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';

import 'page.dart';

//cho phép người dùng hiển thị một hình ảnh lên một khu vực xác định trên bản đồ Map4D
class ImageOverlayPage extends Map4dMapExampleAppPage {
  const ImageOverlayPage({super.key})
      : super(const Icon(Icons.map), 'Image overlay');

  @override
  Widget build(BuildContext context) {
    return const ImageOverlayBody();
  }
}

class ImageOverlayBody extends StatefulWidget {
  const ImageOverlayBody({super.key});

  @override
  State<StatefulWidget> createState() => ImageOverlayBodyState();
}

class ImageOverlayBodyState extends State<ImageOverlayBody> {
  ImageOverlayBodyState();

  MFMapViewController? controller;
  MFBitmap? _image; //Hình ảnh hiển thị trên bản đồ
  MFImageOverlay? _imageOverlay; //đối tượng

  void _onMapCreated(MFMapViewController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  //set đối tượng = null
  void _removeImageOverlay() {
    setState(() {
      _imageOverlay = null;
    });
  }

  void _addImageOverlay() {
    //Góc đông bắc của hình chữ nhật.
    const northeast = MFLatLng(16.066154, 108.207276);
    //Góc tây nam của hình chữ nhật.
    const southwest = MFLatLng(16.020262, 108.189487);
    //Khu vực hiển thị hình ảnh
    final bounds = MFLatLngBounds(southwest: southwest, northeast: northeast);
    final imageOverlay = MFImageOverlay(
      imageOverlayId: const MFImageOverlayId('image_overlay_1'),
      image: _image!,
      bounds: bounds,
    );
    //đối tượng chung
    setState(() {
      _imageOverlay = imageOverlay;
    });
  }

  //Độ trong suốt của image overlay
  void _changeTransparency() {
    if (_imageOverlay != null) {
      final transparency = 0.5 - _imageOverlay!.transparency;
      final overlayWithNewTransparency = _imageOverlay!.copyWith(
        transparencyParam: transparency,
      );
      setState(() {
        _imageOverlay = overlayWithNewTransparency;
      });
    }
  }

  //tạo Hình ảnh hiển thị
  Future<void> _createImageFromAsset(BuildContext context) async {
    if (_image == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      _image = await MFBitmap.fromAssetImage(
          imageConfiguration, 'assets/image_overlay.jpg');
    }
  }

  @override
  Widget build(BuildContext context) {
    _createImageFromAsset(context);
    Set<MFImageOverlay> overlays = <MFImageOverlay>{
      if (_imageOverlay != null) _imageOverlay!,
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 350.0,
            height: 400.0,
            child: MFMapView(
              initialCameraPosition: const MFCameraPosition(
                target: MFLatLng(16.043208, 108.198382),
                zoom: 13.0,
              ),
              //hiển thị image lên bản đồ
              imageOverlays: overlays,
              onMapCreated: _onMapCreated,
            ),
          ),
        ),
        TextButton(
          onPressed: _imageOverlay == null ? _addImageOverlay : null,
          child: const Text('Add image overlay'),
        ),
        TextButton(
          onPressed: _imageOverlay != null ? _removeImageOverlay : null,
          child: const Text('Remove image overlay'),
        ),
        TextButton(
          onPressed: _imageOverlay != null ? _changeTransparency : null,
          child: const Text('Change transparency'),
        ),
      ],
    );
  }
}
