// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StepModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StepModel _$StepModelFromJson(Map<String, dynamic> json) => StepModel(
      maneuver: json['maneuver'] as String,
      htmlInstructions: json['htmlInstructions'] as String,
      distance: (json['distance']['value'] as num).toDouble(),
    );

Map<String, dynamic> _$StepModelToJson(StepModel instance) => <String, dynamic>{
      'maneuver': instance.maneuver,
      'htmlInstructions': instance.htmlInstructions,
      'distance': instance.distance,
    };
