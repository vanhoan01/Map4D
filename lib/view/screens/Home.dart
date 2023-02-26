// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map4d_map/map4d_map.dart';
import 'package:map4dmap/model/model/PlaceDetail.dart';
import 'package:map4dmap/view/directions/DirectionsRendererScreen.dart';
import 'package:map4dmap/view/pages/locationLocation.dart';
import 'package:map4dmap/view/pages/locationMap4d.dart';
import 'package:map4dmap/view/pages/notificationPage.dart';
import 'package:map4dmap/view/screens/MenuOverlayScreen.dart';
import 'package:map4dmap/view/search/SearchDelegateScreen.dart';
import 'package:map4dmap/view/search/components/Search.dart';
import 'package:map4dmap/view/search/components/search_results/BottomPlaceDetail.dart';
import 'package:map4dmap/view/search/components/search_results/BottomPlaceListDetail.dart';
import 'package:map4dmap/view/search/components/search_results/BottomPlaceListHorizontal.dart';
import 'package:map4dmap/view_model/PlaceDetailListViewModel.dart';
import 'package:map4dmap/view_model/PlaceDetailViewModel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    Container(),
    const locationMap4d(),
    const locationLocation(),
    const notificationPage(),
  ];
  FlutterSecureStorage storage = const FlutterSecureStorage();
  String? location;

  late MFMapViewController controller;
  MFLatLng _kLatLng = const MFLatLng(16.0324816, 108.132794);
  MFLatLng cameraPosition = const MFLatLng(16.0324816, 108.132794);
  Map<MFMarkerId, MFMarker> markers = <MFMarkerId, MFMarker>{};
  late LocationSettings locationSettings;
  final PlaceDetailViewModel placeDetailViewModel = PlaceDetailViewModel();
  PlaceDetail? _placeDetail;
  List<PlaceDetail>? _placeSearchTerms;
  bool showType = true;
  String textSearch = "Tìm kiếm ở đây";

  Future<void> getLocation() async {
    String? lct = await storage.read(key: "location");
    setState(() async {
      location = lct;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 66,
        automaticallyImplyLeading: false,
        leadingWidth: 47,
        actions: <Widget>[
          _placeDetail == null
              ? InkWell(
                  onTap: () => _navigateSearchAndChoose(context),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 17),
                    child: SizedBox(
                      width: 30,
                      child: Image(
                        image: AssetImage('assets/google-maps.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        markers.clear();
                        _placeDetail = null;
                        _placeSearchTerms = null;
                        textSearch = "Tìm kiếm ở đây";
                      });
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
          Expanded(
            child: InkWell(
              onTap: () => _navigateSearchAndChoose(context),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  textSearch,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          _placeDetail == null
              ? Padding(
                  padding: const EdgeInsets.only(right: 17),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => const MenuOverlayScreen(),
                      );
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 17,
                      child: ClipOval(
                        child: Image(
                          image: AssetImage('assets/onion.jpg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 39, right: 8, left: 8, bottom: 8),
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
      ),
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
            onCameraMove: (position) {
              setState(() {
                cameraPosition = MFLatLng(
                    position.target.latitude, position.target.longitude);
              });
            },
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
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
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
      bottomNavigationBar: _placeDetail == null
          ? BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_on),
                  label: 'Geolocator',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.time_to_leave),
                  label: 'API Google',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_outline),
                  label: 'Google Map',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_none),
                  label: 'Thông tin',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey[600],
              onTap: _onItemTapped,
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              selectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
            )
          : null,
    );
  }

  Future<void> _navigateSearchAndChoose(BuildContext context) async {
    var result = await showSearchWidget(
      context: context,
      delegate: SearchDelegateScreen(
        location: cameraPosition,
        searchFieldLabel: "Tìm kiếm ở đây",
        searchFieldStyle: const TextStyle(
          color: Color.fromRGBO(158, 158, 158, 1),
          fontSize: 18,
        ),
      ),
    );
    if (result is PlaceDetail) {
      setState(() {
        markers = <MFMarkerId, MFMarker>{};
        _placeDetail = result;
        textSearch = result.name;
      });
      addMarkers(
        result.location.lat,
        result.location.lng,
        () {},
      );
      await controller.animateCamera(MFCameraUpdate.newLatLngZoom(
          MFLatLng(result.location.lat, result.location.lng), 17));
    } else {
      if (result is String) {
        setState(() {
          showType = true;
        });
        getPlaceResultsList(result);
      }
    }
  }

  void getPlaceResultsList(String text) async {
    PlaceDetailListViewModel placeDetailListViewModel =
        PlaceDetailListViewModel();
    List<PlaceDetail> list = await placeDetailListViewModel.getTextSearch(
        text, '${cameraPosition.latitude},${cameraPosition.longitude}');
    PlaceDetail placeDetail = list[0];

    setState(() {
      _placeSearchTerms = list;
      _placeDetail = placeDetail;
      _kLatLng = MFLatLng(placeDetail.location.lat, placeDetail.location.lng);
      textSearch = text;
      markers = <MFMarkerId, MFMarker>{};
    });
    addMarkersList();
    await controller.animateCamera(MFCameraUpdate.newLatLngZoom(
        MFLatLng(placeDetail.location.lat, placeDetail.location.lng), 15));
  }

  void getPlaceDetail(placeId) async {
    PlaceDetail placeDetail =
        await placeDetailViewModel.getPlaceDetail(placeId);
    // ignore: avoid_print
    print('id ${placeDetail.id}, address ${placeDetail.address}');

    setState(() {
      markers = <MFMarkerId, MFMarker>{};
      _kLatLng = MFLatLng(placeDetail.location.lat, placeDetail.location.lng);
      _placeDetail = placeDetail;
      textSearch = placeDetail.name;
    });
    addMarkers(
      placeDetail.location.lat,
      placeDetail.location.lng,
      () {},
    );
    // ignore: avoid_print
    print('_kLatLng: $_kLatLng');
    await controller.animateCamera(MFCameraUpdate.newLatLngZoom(
        MFLatLng(_kLatLng.latitude, _kLatLng.longitude), 17));
  }

  void addMarkersList() {
    for (var place in _placeSearchTerms ?? []) {
      addMarkers(
        place.location.lat,
        place.location.lng,
        () {
          if (GlobalObjectKey(place.id).currentContext != null) {
            Scrollable.ensureVisible(
              GlobalObjectKey(place.id).currentContext!,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        },
      );
    }
  }

  void addMarkers(double latitude, double longitude, Function() funtion) {
    String coordinatesString = '$latitude, $longitude';

    MFMarker marker = MFMarker(
      markerId: MFMarkerId(coordinatesString),
      position: MFLatLng(latitude, longitude),
      infoWindow: MFInfoWindow(
        title: 'Point $coordinatesString',
        snippet: coordinatesString,
      ),
      icon: MFBitmap.defaultIcon,
      onTap: funtion,
    );

    // Thêm các điểm đánh dấu vào danh sách
    setState(() {
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
    return position;
  }

  void getUserLocation() async {
    String? location = await storage.read(key: "location");
    if (location == null) {
      await storage.write(
          key: "location", value: '${_kLatLng.latitude},${_kLatLng.longitude}');
    } else {
      // ignore: avoid_print
      print("locationstorage: $location");
      List<String> latlong = location.split(",");
      setState(() {
        _kLatLng = MFLatLng(double.parse(latlong[0]), double.parse(latlong[1]));
      });
      // ignore: avoid_print
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
      // ignore: avoid_print
      print(
          "location: ${currentLocation.latitude},${currentLocation.longitude}");
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> _onTap(MFLatLng coordinate) async {
    // ignore: avoid_print
    print('coordinate: $coordinate');

    if (_placeSearchTerms == null) {
      PlaceDetail placeDetail =
          await placeDetailViewModel.getGeocodev2(coordinate);

      // ignore: avoid_print
      print('id ${placeDetail.id}, address ${placeDetail.address}');
      addMarkers(
        placeDetail.location.lat,
        placeDetail.location.lng,
        () {},
      );
      setState(() {
        markers = <MFMarkerId, MFMarker>{};
        _placeDetail = placeDetail;
        textSearch = placeDetail.name;
      });
      await controller.animateCamera(MFCameraUpdate.newLatLngZoom(
          MFLatLng(placeDetail.location.lat, placeDetail.location.lng), 17));
    }
  }

  Future<void> _onPOITap(String placeId, String name, MFLatLng location) async {
    // ignore: avoid_print
    print('id');
    if (_placeSearchTerms == null) {
      getPlaceDetail(placeId);
    }
  }
}
