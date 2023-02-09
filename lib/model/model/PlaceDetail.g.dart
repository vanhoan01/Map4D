// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PlaceDetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceDetail _$PlaceDetailFromJson(Map<String, dynamic> json) => PlaceDetail(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      location: LocationModel(
          lng: json['location']['lng'] as double,
          lat: json['location']['lat'] as double),
      types: (json['types'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PlaceDetailToJson(PlaceDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'location': instance.location,
      'types': instance.types,
    };
