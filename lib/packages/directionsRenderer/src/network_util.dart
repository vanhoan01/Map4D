import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:map4dmap/model/modelList/StepList.dart';

import '../src/PointLatLng.dart';
import '../src/utils/polyline_waypoint.dart';
import '../src/utils/request_enums.dart';
import 'utils/polyline_result.dart';

class NetworkUtil {
  // ignore: constant_identifier_names
  static const String STATUS_OK = "ok";

  ///Get the encoded string from google directions api
  ///
  Future<PolylineResult> getRouteBetweenCoordinates(
    String googleApiKey,
    String origin,
    // PointLatLng destination,
    String destination,
    TravelMode travelMode,
    List<PolylineWayPoint> points,
  ) async {
    String mode = travelMode.toString().replaceAll('TravelMode.', '');
    PolylineResult result = PolylineResult();
    var params = {
      "key": googleApiKey,
      "origin": origin,
      // "destination": "${destination.latitude},${destination.longitude}",
      "destination": destination,
      "mode": mode,
      // "avoidHighways": "$avoidHighways",
      // "avoidFerries": "$avoidFerries",
      // "avoidTolls": "$avoidTolls",
    };
    if (points.isNotEmpty) {
      List pointsArray = [];
      for (var point in points) {
        pointsArray.add(point.location);
      }
      String pointsString = pointsArray.join('|');
      params.addAll({"points": pointsString});
    }
    String url =
        'http://api.map4d.vn/sdk/route?key=$googleApiKey&origin=$origin&destination=$destination&mode=$mode';
    // String url =
    //     'http://api.map4d.vn/sdk/route?key=cdce1abbdd677c69b9a258a76874c356&origin=16.024634,108.209217&destination=16.020179,108.211212&mode=motorcycle';
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {"Content-type": "application/json"},
      );
      // Uri uri = Uri.https("api.map4d.vn", "sdk/route", params);

      // print('GOOGLE MAPS URL: ' + url);
      // var response = await http.get(uri);
      if (response.statusCode == 200) {
        var parsedJson = json.decode(response.body);
        // print("response.body: ${response.body}");
        result.code = parsedJson["code"];
        if (parsedJson["code"]?.toLowerCase() == STATUS_OK &&
            parsedJson["result"]["routes"] != null &&
            parsedJson["result"]["routes"].isNotEmpty) {
          result.points = decodeEncodedPolyline(
              parsedJson["result"]["routes"][0]["overviewPolyline"]);
          result.distance =
              parsedJson['result']['routes'][0]['legs'][0]['distance']['value'];
          result.duration =
              parsedJson['result']['routes'][0]['legs'][0]['duration']['value'];
          // print(
          //     "stepList: ${parsedJson['result']['routes'][0]['legs'][0]['steps']}");
          StepList stepList = StepList();
          //StepModelFromJson json['distance']['value'] as num
          stepList = StepList.fromJson(
              parsedJson['result']['routes'][0]['legs'][0]['steps']);
          // ignore: avoid_print
          print('stepList.data: ${stepList.data}');
          result.steps = stepList.data;
        } else {
          result.errorMessage = parsedJson["error_message"];
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return result;
  }

  ///decode the google encoded string using Encoded Polyline Algorithm Format
  /// for more info about the algorithm check https://developers.google.com/maps/documentation/utilities/polylinealgorithm
  ///
  ///return [List]
  List<PointLatLng> decodeEncodedPolyline(String encoded) {
    List<PointLatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      PointLatLng p =
          PointLatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }
}
