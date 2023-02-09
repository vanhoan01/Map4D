// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';
import 'package:map4dmap/model/model/LocationModel.dart';

part "PlaceDetail.g.dart";

//http://api.map4d.vn/sdk/place/detail/60a73ddfb4e1e72f18938426?key=cdce1abbdd677c69b9a258a76874c356
@JsonSerializable()
class PlaceDetail {
  final String id;
  final String name;
  final String address;
  final LocationModel location;
  final List<String> types;

  PlaceDetail({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.types,
  });
  factory PlaceDetail.fromJson(Map<String, dynamic> json) =>
      _$PlaceDetailFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceDetailToJson(this);
}

//flutter pub run build_runner build
