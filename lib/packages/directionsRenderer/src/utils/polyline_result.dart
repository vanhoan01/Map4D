import 'package:map4dmap/model/model/StepModel.dart';

import '../../flutter_polyline_points.dart';

/// description:
/// project: flutter_polyline_points
/// @package:
/// @author: dammyololade
/// created on: 13/05/2020
class PolylineResult {
  /// the api status retuned from google api
  ///
  /// returns OK if the api call is successful
  String? code;

  /// list of decoded points
  List<PointLatLng> points;

  /// the error message returned from google, if none, the result will be empty
  String? errorMessage;

  double? distance;
  int? duration;
  List<StepModel>? steps;

  PolylineResult({
    this.code,
    this.points = const [],
    this.errorMessage = "",
    this.distance,
    this.duration,
    this.steps,
  });
}
