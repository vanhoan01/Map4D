// ignore_for_file: file_names, avoid_print

import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map4d_map/map4d_map.dart';
import 'package:map4dmap/api/secrets.dart';
import 'package:map4dmap/model/StepModel.dart';
import '../../directionsRenderer/flutter_polyline_points.dart';

// ignore: camel_case_types
class DirectionsRendererScreen extends StatefulWidget {
  const DirectionsRendererScreen({Key? key}) : super(key: key);

  @override
  State<DirectionsRendererScreen> createState() =>
      _DirectionsRendererScreenState();
}

// ignore: camel_case_types
class _DirectionsRendererScreenState extends State<DirectionsRendererScreen> {
  late MFMapViewController controller;

  MFLatLng _kLatLng = const MFLatLng(16.0324816, 108.132794);
  MFBitmap? _iconStart;
  TravelMode _travelMode = TravelMode.motorcycle;
  Set<MFMarker> markers = {};
  late LocationSettings locationSettings;

  late Position _currentPosition;
  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  String _currentAddress = '';
  String _startAddress = '';
  String _destinationAddress = '';
  String? _placeDistance;
  double? _distance;
  int? _duration;
  String _choose = 'start';
  List<StepModel>? _steps;

  int modevalue = 0;
  // car, bike, foot, motorcycle

  late PolylinePoints polylinePoints;
  Map<MFPolylineId, MFPolyline> polylines = {};
  List<MFLatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    getUserLocation();
    _getCurrentLocation();
  }

  Widget _textField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required double width,
    required Widget prefixIcon,
    Widget? suffixIcon,
    required Function(String) locationCallback,
  }) {
    return SizedBox(
      width: width * 0.75,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue.shade300,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.all(15),
          hintText: hint,
          // hintStyle: TextStyle(color: Colors.black26),
        ),
        onTap: null,
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget CustomRadioButton(Icon icon, String text, int index) {
    return TextButton.icon(
      onPressed: () {
        setState(() {
          modevalue = index;
          _travelMode = TravelMode.values[index];
          if (polylines.isNotEmpty) {
            directionsRenderrer();
          }
        });
      },
      icon: icon,
      label: Text(
        text,
        style: TextStyle(
          color: (modevalue == index) ? Colors.blueAccent : Colors.black,
        ),
      ),
      style: TextButton.styleFrom(
          foregroundColor: Colors.blueAccent,
          backgroundColor:
              (modevalue == index) ? Colors.blue.shade100 : Colors.white),
    );
  }

  List<String> animalNames = ['Elephant', 'Tiger', 'Kangaroo'];
  final Map<String, IconData> myIconCollection = {
    'turn-slight-left': Icons.turn_slight_left,
    'turn-sharp-left': Icons.turn_sharp_left,
    'uturn-left': Icons.u_turn_left,
    'turn-left': Icons.turn_left,
    'turn-slight-right': Icons.turn_slight_right,
    'turn-sharp-right': Icons.turn_sharp_right,
    'uturn-right': Icons.u_turn_right,
    'turn-right': Icons.turn_right,
    'straight': Icons.straight,
    'ramp-left': Icons.ramp_left,
    'ramp-right': Icons.ramp_right,
    'merge': Icons.merge,
    'fork-left': Icons.fork_left,
    'fork-right': Icons.fork_right,
    'ferry': Icons.directions_ferry,
    'ferry-train': Icons.directions_train,
    'roundabout-left': Icons.roundabout_left,
    'roundabout-right': Icons.roundabout_right,
  };

  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset(context);
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          MFMapView(
            initialCameraPosition: MFCameraPosition(
              target: _kLatLng,
              zoom: 13.0,
            ),
            markers: Set<MFMarker>.of(markers),
            //markers: Set<MFMarker>.of(markers.values),
            polylines: Set<MFPolyline>.of(polylines.values),
            onMapCreated: _onMapCreated,
            onPOITap: _onPOITap,
            onTap: _onTap,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: Colors.white,
                width: width,
                padding: const EdgeInsets.only(top: 15, bottom: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const SizedBox(
                            width: 45,
                            height: 45,
                            child: Icon(Icons.arrow_back),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _textField(
                                controller: startAddressController,
                                focusNode: startAddressFocusNode,
                                label: 'Điểm bắt đầu',
                                hint: 'Chọn điểm bắt đầu',
                                width: width,
                                prefixIcon: InkWell(
                                  child: Icon(
                                    _choose == 'start'
                                        ? Icons.circle
                                        : Icons.circle_outlined,
                                    color: Colors.blueAccent,
                                    size: 20,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      if (_choose == 'start') {
                                        _choose = 'end';
                                      } else {
                                        _choose = 'start';
                                      }
                                    });
                                  },
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.my_location),
                                  onPressed: () {
                                    _getCurrentLocation();
                                    startAddressController.text =
                                        'Vị trí của tôi';
                                    _startAddress = _currentAddress;
                                    clearOne('start');
                                    addMarkers(_currentPosition.latitude,
                                        _currentPosition.longitude, 'start');
                                  },
                                ),
                                locationCallback: (String value) {
                                  setState(() {
                                    _startAddress = value;
                                  });
                                }),
                            const SizedBox(height: 10),
                            _textField(
                                label: 'Điểm đến',
                                hint: 'Chọn điểm đến',
                                prefixIcon: InkWell(
                                  child: Icon(
                                    _choose == 'end'
                                        ? Icons.location_on
                                        : Icons.location_on_outlined,
                                    color: Colors.redAccent,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      if (_choose == 'start') {
                                        _choose = 'end';
                                      } else {
                                        _choose = 'start';
                                      }
                                    });
                                  },
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.directions,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: (_startAddress != '' &&
                                          _destinationAddress != '')
                                      ? () async {
                                          startAddressFocusNode.unfocus();
                                          desrinationAddressFocusNode.unfocus();
                                          setState(() {
                                            if (markers.isNotEmpty) {
                                              markers.clear();
                                            }
                                            if (polylines.isNotEmpty) {
                                              polylines.clear();
                                            }
                                            if (polylineCoordinates
                                                .isNotEmpty) {
                                              polylineCoordinates.clear();
                                            }
                                            _placeDistance = null;
                                            _distance = null;
                                            _duration = null;
                                            _steps = null;
                                          });

                                          _calculateDistance()
                                              .then((isCalculated) {
                                            if (!isCalculated) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content:
                                                      Text('Error chỉ đường'),
                                                ),
                                              );
                                            }
                                          });
                                        }
                                      : null,
                                ),
                                controller: destinationAddressController,
                                focusNode: desrinationAddressFocusNode,
                                width: width,
                                locationCallback: (String value) {
                                  setState(() {
                                    _destinationAddress = value;
                                  });
                                }),
                            const SizedBox(height: 5),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            String nameStart = startAddressController.text;
                            String addressStart = _startAddress;
                            setState(() {
                              startAddressController.text =
                                  destinationAddressController.text;
                              _startAddress = _destinationAddress;
                              destinationAddressController.text = nameStart;
                              _destinationAddress = addressStart;
                            });
                            if (polylines.isNotEmpty) {
                              directionsRenderrer();
                            }
                          },
                          child: const Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                                height: 107,
                                width: 45,
                                // color: Colors.red,
                                child: Icon(
                                  Icons.swap_vert,
                                  size: 28,
                                )),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomRadioButton(
                            Icon(Icons.directions_car_outlined,
                                size: 20,
                                color: (modevalue == 0)
                                    ? Colors.blueAccent
                                    : Colors.black),
                            "Xe hơi",
                            0),
                        CustomRadioButton(
                            Icon(Icons.motorcycle_outlined,
                                size: 20,
                                color: (modevalue == 1)
                                    ? Colors.blueAccent
                                    : Colors.black),
                            "Xe máy",
                            1),
                        CustomRadioButton(
                            Icon(Icons.directions_bike_outlined,
                                size: 20,
                                color: (modevalue == 2)
                                    ? Colors.blueAccent
                                    : Colors.black),
                            "Xe đạp",
                            2),
                        CustomRadioButton(
                            Icon(Icons.directions_walk,
                                size: 20,
                                color: (modevalue == 3)
                                    ? Colors.blueAccent
                                    : Colors.black),
                            "Đi bộ",
                            3)
                      ],
                    ),
                    Visibility(
                      visible: _distance == null ? false : true,
                      child: Text(
                        '${_duration ?? 0} phút (${_distance ?? 0} km)',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _steps == null ? Container() : bottomDetailsSheet(),
        ],
      ),
    );
  }

  Widget bottomDetailsSheet() {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        initialChildSize: .1,
        minChildSize: .1,
        maxChildSize: 0.97,
        snap: true,
        snapSizes: const [0.7],
        builder: (BuildContext context, ScrollController scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5.0,
                    spreadRadius: 20.0,
                    offset: const Offset(0.0, 5.0),
                    color: Colors.black.withOpacity(0.1),
                  )
                ],
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Spacer(),
                      Container(
                        height: 5,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_duration ?? 0} phút (${_distance ?? 0} km)',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 1,
                    color: Colors.grey.shade300,
                    width: MediaQuery.of(context).size.width,
                  ),

                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        const Text(
                          'Các chặng',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        stepDirection(
                          const Icon(
                            Icons.circle_outlined,
                            // color: Colors.blueAccent,
                            size: 28,
                          ),
                          startAddressController.text,
                          0,
                        ),
                        for (var step in _steps!)
                          stepDirection(
                            myIconCollection[step.maneuver] == null
                                ? Icon(
                                    myIconCollection['straight'],
                                    size: 28,
                                  )
                                : Icon(
                                    myIconCollection[step.maneuver],
                                    size: 28,
                                  ),
                            step.htmlInstructions,
                            step.distance.round(),
                          ),
                        stepDirection(
                          const Icon(
                            Icons.location_on_outlined,
                            size: 28,
                          ),
                          destinationAddressController.text,
                          0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  //   child: Container(
                  //     color: Colors.grey,
                  //     child: ListTile(
                  //       title: Text(
                  //         "Các chặng",
                  //       ),
                  //       leading: Icon(Icons.list),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget stepDirection(Icon icon, String instructions, int distance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: icon),
            Text(
              instructions,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const SizedBox(width: 48),
            Text(
              distance == 0 ? '' : '$distance m',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Container(
                height: 1,
                color: Colors.grey.shade300,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  directionsRenderrer() {
    startAddressFocusNode.unfocus();
    desrinationAddressFocusNode.unfocus();
    setState(
      () {
        if (markers.isNotEmpty) markers.clear();
        if (polylines.isNotEmpty) polylines.clear();
        if (polylineCoordinates.isNotEmpty) {
          polylineCoordinates.clear();
        }
        _placeDistance = null;
        _distance = null;
        _duration = null;
        _steps = null;
      },
    );

    _calculateDistance().then(
      (isCalculated) {
        if (isCalculated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Distance Calculated Sucessfully'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error Calculating Distance'),
            ),
          );
        }
      },
    );
  }

  //Phương pháp tính khoảng cách giữa hai địa điểm
  Future<bool> _calculateDistance() async {
    try {
      // Truy xuất dấu vị trí từ địa chỉ
      List<Location> startPlacemark = await locationFromAddress(_startAddress);
      List<Location> destinationPlacemark =
          await locationFromAddress(_destinationAddress);

      double startLatitude = _startAddress == _currentAddress
          ? _currentPosition.latitude
          : startPlacemark[0].latitude;

      double startLongitude = _startAddress == _currentAddress
          ? _currentPosition.longitude
          : startPlacemark[0].longitude;

      double destinationLatitude = destinationPlacemark[0].latitude;
      double destinationLongitude = destinationPlacemark[0].longitude;
      print("destination destination destination destination destination ");
      print(destinationPlacemark[0].latitude);
      print(destinationPlacemark[0].longitude);

      addMarkers(startLatitude, startLongitude, 'start');
      addMarkers(destinationLatitude, destinationLongitude, 'destination');

      if (kDebugMode) {
        print(
          'START COORDINATES: ($startLatitude, $startLongitude)',
        );
      }
      if (kDebugMode) {
        print(
          'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
        );
      }

      double miny = (startLatitude <= destinationLatitude)
          ? startLatitude
          : destinationLatitude;
      double minx = (startLongitude <= destinationLongitude)
          ? startLongitude
          : destinationLongitude;
      double maxy = (startLatitude <= destinationLatitude)
          ? destinationLatitude
          : startLatitude;
      double maxx = (startLongitude <= destinationLongitude)
          ? destinationLongitude
          : startLongitude;

      double southWestLatitude = miny;
      double southWestLongitude = minx;

      double northEastLatitude = maxy;
      double northEastLongitude = maxx;

      // Chứa hai vị trí trong chế độ xem camera của bản đồ
      controller.animateCamera(
        MFCameraUpdate.newLatLngBounds(
          MFLatLngBounds(
            northeast: MFLatLng(northEastLatitude, northEastLongitude),
            southwest: MFLatLng(southWestLatitude, southWestLongitude),
          ),
          17.0,
        ),
      );

      await _createPolylines(
        _startAddress,
        _destinationAddress,
      );

      double totalDistance = 0.0;

      // Tính tổng khoảng cách bằng cách thêm khoảng cách
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      setState(() {
        _placeDistance = totalDistance.toStringAsFixed(2);
        print('DISTANCE: $_placeDistance km');
      });

      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  //Phương thức truy xuất địa chỉ
  _getAddress() async {
    try {
      setState(() {
        _currentAddress =
            "${_currentPosition.latitude},${_currentPosition.longitude}";
        startAddressController.text = 'Vị trí của tôi';
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  _createPolylines(
    String origin,
    String destination,
  ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.MAP4D_API_KEY, // Google Maps API Key
      origin,
      destination,
      travelMode: _travelMode,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(MFLatLng(point.latitude, point.longitude));
      }
    }

    MFPolylineId id = const MFPolylineId('poly');
    MFPolyline polyline = MFPolyline(
        polylineId: id,
        color: Colors.blueAccent,
        points: polylineCoordinates,
        width: 6,
        style: modevalue != 3 ? MFPolylineStyle.solid : MFPolylineStyle.dotted);

    double? distance = result.distance;
    int? duration = result.duration;
    print('result.stepList: ${result.steps}');
    setState(() {
      polylines[id] = polyline;
      _distance = double.parse((distance! / 1000).toStringAsFixed(1));
      _duration = (duration! / 60).ceil();
      _steps = result.steps;
    });
    print('_steps: $_steps');
    print('polyline: ${polyline.points}');
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_iconStart == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      _iconStart = await MFBitmap.fromAssetImage(
          imageConfiguration, 'assets/ic_my_location.png');
    }
  }

  void _onMapCreated(MFMapViewController controller) {
    this.controller = controller;
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
    try {
      Position currentLocation = await _determinePosition();
      setState(() {
        _currentPosition = currentLocation;
        _kLatLng =
            MFLatLng(currentLocation.latitude, currentLocation.longitude);
      });
    } catch (e) {
      print(e);
    }
  }

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        controller.animateCamera(
          MFCameraUpdate.newCameraPosition(
            MFCameraPosition(
              target: MFLatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  void clearOne(String choose) {
    startAddressFocusNode.unfocus();
    desrinationAddressFocusNode.unfocus();
    setState(() {
      if (markers.isNotEmpty) {
        choose == 'start'
            ? markers.removeWhere(
                (element) => element.markerId.value.startsWith('start'))
            : markers.removeWhere(
                (element) => element.markerId.value.startsWith('destination'));
      }
      if (polylines.isNotEmpty) polylines.clear();
      if (polylineCoordinates.isNotEmpty) polylineCoordinates.clear();
      _placeDistance = null;
      _distance = null;
      _duration = null;
      _steps = null;
    });
  }

  void addMarkers(double latitude, double longitude, String type) {
    String coordinatesString = type == 'start'
        ? 'start($latitude, $longitude)'
        : 'destination($latitude, $longitude)';

    // Bắt đầu đánh dấu vị trí
    MFMarker marker = MFMarker(
      markerId: MFMarkerId(coordinatesString),
      position: MFLatLng(latitude, longitude),
      infoWindow: MFInfoWindow(
        title: 'Start $coordinatesString',
        snippet: type == 'start' ? _startAddress : _destinationAddress,
      ),
      icon: type == 'start' ? _iconStart! : MFBitmap.defaultIcon,
    );

    // Thêm các điểm đánh dấu vào danh sách
    markers.add(marker);
  }

  void _onTap(MFLatLng location) {
    String address = '${location.latitude},${location.longitude}';
    setState(() {
      if (_choose == 'start') {
        startAddressController.text = address;
        _startAddress = address;
      } else {
        destinationAddressController.text = address;
        _destinationAddress = address;
      }
    });
    clearOne(_choose);
    addMarkers(location.latitude, location.longitude, _choose);
  }

  void _onPOITap(String placeId, String name, MFLatLng location) {
    print('Tap on place: $placeId, name: $name, location: $location');
    String address = '${location.latitude},${location.longitude}';
    print(address);
    setState(() {
      if (_choose == 'start') {
        startAddressController.text = name;
        _startAddress = address;
      } else {
        destinationAddressController.text = name;
        _destinationAddress = address;
      }
    });
    clearOne(_choose);
    addMarkers(location.latitude, location.longitude, _choose);
  }
}

//https://github.com/map4d/map4d-map-flutter/blob/master/example/lib/place_polyline.dart
//https://docs.map4d.vn/map4d-service/api/v1.2/#/api_route