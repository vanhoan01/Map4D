// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';
import 'package:map4dmap/model/model/StepModel.dart';

part 'StepList.g.dart';

@JsonSerializable()
class StepList {
  final List<StepModel>? data;
  StepList({this.data});
  factory StepList.fromJson(List<dynamic> json) => _$StepListFromJson(json);
  Map<String, dynamic> toJson() => _$StepListToJson(this);
}
//flutter pub run build_runner build