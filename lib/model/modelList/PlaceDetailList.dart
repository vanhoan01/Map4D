// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';
import 'package:map4dmap/model/model/PlaceDetail.dart';

part 'PlaceDetailList.g.dart';

@JsonSerializable()
class PlaceDetailList {
  final List<PlaceDetail>? data;
  PlaceDetailList({this.data});
  factory PlaceDetailList.fromJson(Map<String, dynamic> json) =>
      _$PlaceDetailListFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceDetailListToJson(this);
}
//flutter pub run build_runner build