// ignore_for_file: file_names, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map4d_map/map4d_map.dart';
import 'package:map4dmap/model/model/PlaceDetail.dart';
import 'package:map4dmap/view/directions/DirectionsRendererScreen.dart';
import 'package:map4dmap/view/search/components/search_results/BottomPlaceDetail.dart';
import 'package:map4dmap/view/search/components/search_results/BottomPlaceListDetail.dart';
import 'package:map4dmap/view/search/components/search_results/BottomPlaceListHorizontal.dart';
import 'package:map4dmap/view_model/PlaceDetailListViewModel.dart';
import 'package:map4dmap/view_model/PlaceDetailViewModel.dart';

// ignore: camel_case_types
class locationGeolocator extends StatefulWidget {
  const locationGeolocator({Key? key, this.locationId, this.text})
      : super(key: key);
  final String? locationId;
  final String? text;
  static const routeName = '/locationGeolocator';
  @override
  State<locationGeolocator> createState() => _locationGeolocatorState();
}

// ignore: camel_case_types
class _locationGeolocatorState extends State<locationGeolocator> {
  late MFMapViewController controller;
  MFLatLng _kLatLng = const MFLatLng(16.0324816, 108.132794);
  Map<MFMarkerId, MFMarker> markers = <MFMarkerId, MFMarker>{};
  late LocationSettings locationSettings;
  final PlaceDetailViewModel placeDetailViewModel = PlaceDetailViewModel();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  PlaceDetail? _placeDetail;
  List<PlaceDetail>? _placeSearchTerms;
  String? location;
  bool showType = true;

  @override
  void initState() {
    getLocation();
    if (widget.locationId != null) {
      getPlaceDetail(widget.locationId);
    } else {
      if (widget.text != null) {
        getPlaceResultsList();
      } else {
        getUserLocation();
      }
    }
    super.initState();
  }

  Future<void> getLocation() async {
    String? lct = await storage.read(key: "location");
    setState(() async {
      location = lct;
    });
  }

  void getPlaceResultsList() async {
    PlaceDetailListViewModel placeDetailListViewModel =
        PlaceDetailListViewModel();
    List<PlaceDetail> list = await placeDetailListViewModel.getTextSearch(
        widget.text!, location ?? '16.036505,108.218186');
    PlaceDetail placeDetail = list[0];

    setState(() {
      _placeSearchTerms = list;
      _placeDetail = placeDetail;
      _kLatLng = MFLatLng(placeDetail.location.lat, placeDetail.location.lng);
    });
    addMarkersList();
  }

  void getPlaceDetail(placeId) async {
    PlaceDetail placeDetail =
        await placeDetailViewModel.getPlaceDetail(placeId);
    print('id ${placeDetail.id}, address ${placeDetail.address}');
    addMarkers(placeDetail.location.lat, placeDetail.location.lng);
    setState(() {
      _kLatLng = MFLatLng(placeDetail.location.lat, placeDetail.location.lng);
      _placeDetail = placeDetail;
    });
    print('_kLatLng: $_kLatLng');
    await controller.animateCamera(MFCameraUpdate.newLatLngZoom(
        MFLatLng(_kLatLng.latitude, _kLatLng.longitude), 17));
  }

  @override
  Widget build(BuildContext context) {
    if (checkScreenInHome()) {
      markers = <MFMarkerId, MFMarker>{};
      _placeDetail = null;
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _placeDetail == null
          ? null
          : _placeSearchTerms == null
              ? AppBar(
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                  toolbarHeight: 66,
                  automaticallyImplyLeading: false,
                  leadingWidth: 47,
                  title: Text(
                    _placeDetail == null
                        ? 'Tìm kiếm ở đây'
                        : _placeDetail!.name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear, color: Colors.black),
                      ),
                    )
                  ],
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.only(
                        top: 39, right: 8, left: 8, bottom: 8),
                    child: Container(
                      decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(224, 224, 224, 1),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: Colors.white),
                    ),
                  ),
                )
              : null,
      body: Stack(
        children: [
          MFMapView(
            initialCameraPosition: MFCameraPosition(
              target: _kLatLng,
              zoom: 13.0,
            ),
            markers: Set<MFMarker>.of(markers.values),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onMapCreated: _onMapCreated,
            onPOITap: _onPOITap,
            onTap: _onTap,
          ),
          _placeSearchTerms != null
              ? showType == true
                  ? BottomPlaceListDetail(placeDetailList: _placeSearchTerms!)
                  : BottomPlaceListHorizontal(
                      placeDetailList: _placeSearchTerms!,
                      idSrcoll: _placeSearchTerms![1].id,
                    )
              : _placeDetail != null
                  ? BottomPlaceDetail(placeDetail: _placeDetail)
                  : Container(),
        ],
      ),
      floatingActionButton: _placeSearchTerms != null
          ? showType == true
              ? FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () {
                    setState(() {
                      showType = false;
                    });
                  },
                  tooltip: 'Directions',
                  icon: const Icon(Icons.map),
                  label: const Text("Xem bản đồ"),
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 200),
                  child: FloatingActionButton.extended(
                    heroTag: null,
                    onPressed: () {
                      setState(() {
                        showType = true;
                      });
                    },
                    tooltip: 'Directions',
                    icon: const Icon(Icons.list),
                    label: const Text("Xem danh sách"),
                  ),
                )
          : Visibility(
              visible: _placeDetail == null ? true : false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings:
                            const RouteSettings(name: "/DirectionsRenderer"),
                        builder: (context) => const DirectionsRendererScreen(),
                      ),
                    );
                  },
                  tooltip: 'Directions',
                  child: const Icon(Icons.directions),
                ),
              ),
            ),
    );
  }

  void addMarkersList() {
    for (var place in _placeSearchTerms ?? []) {
      addMarkers(place.location.lat, place.location.lng);
    }
  }

  void addMarkers(double latitude, double longitude) {
    String coordinatesString = '$latitude, $longitude';

    MFMarker marker = MFMarker(
      markerId: MFMarkerId(coordinatesString),
      position: MFLatLng(latitude, longitude),
      infoWindow: MFInfoWindow(
        title: 'Point $coordinatesString',
        snippet: coordinatesString,
      ),
      icon: MFBitmap.defaultIcon,
    );

    // Thêm các điểm đánh dấu vào danh sách
    setState(() {
      // markers = <MFMarkerId, MFMarker>{};
      markers[MFMarkerId(coordinatesString)] = marker;
    });
  }

  void _onMapCreated(MFMapViewController controller) {
    this.controller = controller;
    controller.animateCamera(MFCameraUpdate.newLatLngZoom(
        MFLatLng(_kLatLng.latitude, _kLatLng.longitude), 17));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    print(position.longitude);
    return position;
  }

  void getUserLocation() async {
    String? location = await storage.read(key: "location");
    if (location == null) {
      await storage.write(
          key: "location", value: '${_kLatLng.latitude},${_kLatLng.longitude}');
    } else {
      print("locationstorage: $location");
      List<String> latlong = location.split(",");
      setState(() {
        _kLatLng = MFLatLng(double.parse(latlong[0]), double.parse(latlong[1]));
      });
      print("latlong: ${latlong[0]}, ${latlong[1]}");
    }
    try {
      Position currentLocation = await _determinePosition();
      setState(() {
        _kLatLng =
            MFLatLng(currentLocation.latitude, currentLocation.longitude);
      });

      await storage.write(
          key: "location",
          value: '${currentLocation.latitude},${currentLocation.longitude}');
      print(
          "location: ${currentLocation.latitude},${currentLocation.longitude}");
      print("_kLatLng: ${_kLatLng.latitude},${_kLatLng.longitude}");
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onTap(MFLatLng coordinate) async {
    print('coordinate: $coordinate');
    PlaceDetail placeDetail =
        await placeDetailViewModel.getGeocodev2(coordinate);

    setState(() {
      _placeDetail = placeDetail;
    });
  }

  bool checkScreenInHome() {
    var route = ModalRoute.of(context);

    if (route != null) {
      if (route.settings.name == "/") {
        return true;
      }
    }
    return false;
  }

  Future<void> _onPOITap(String placeId, String name, MFLatLng location) async {
    print('id');
    getPlaceDetail(placeId);
    if (checkScreenInHome()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => locationGeolocator(locationId: placeId),
        ),
      );
    }
    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   barrierColor: Colors.transparent,
    //   builder: (context) {
    //     return bottomDetailsSheet();
    //   },
    // );
  }
}
