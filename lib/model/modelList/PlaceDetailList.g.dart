// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PlaceDetailList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceDetailList _$PlaceDetailListFromJson(Map<String, dynamic> json) =>
    PlaceDetailList(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PlaceDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlaceDetailListToJson(PlaceDetailList instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
