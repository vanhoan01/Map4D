// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';

part "StepModel.g.dart";

@JsonSerializable()
class StepModel {
  final String maneuver;
  final String htmlInstructions;
  final double distance;

  StepModel({
    required this.maneuver,
    required this.htmlInstructions,
    required this.distance,
  });
  factory StepModel.fromJson(Map<String, dynamic> json) =>
      _$StepModelFromJson(json);
  Map<String, dynamic> toJson() => _$StepModelToJson(this);
}

//flutter pub run build_runner build
