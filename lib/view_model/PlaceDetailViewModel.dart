// ignore_for_file: file_names

import 'package:map4d_map/map4d_map.dart';
import 'package:map4dmap/data/network_api_services.dart';
import 'package:map4dmap/model/model/PlaceDetail.dart';
import 'package:map4dmap/model/modelList/PlaceDetailList.dart';
import 'package:map4dmap/resources/app_urls.dart';
import 'package:map4dmap/resources/secrets.dart';

class PlaceDetailViewModel {
  NetworkApiService networkApiService = NetworkApiService();

  Future<PlaceDetail> getPlaceDetail(String id) async {
    var responsePD = await networkApiService
        .getApi('${AppUrl.placeDetailUrl}$id?key=${Secrets.MAP4D_API_KEY}');
    PlaceDetail placeDetail = PlaceDetail.fromJson(responsePD['result']);
    return placeDetail;
  }

  Future<PlaceDetail> getGeocodev2(MFLatLng location) async {
    var responsePD = await networkApiService.getApi(
        '${AppUrl.geocodev2Url}?key=${Secrets.MAP4D_API_KEY}&location=${location.latitude},${location.longitude}');
    PlaceDetail placeDetail = PlaceDetail.fromJson(responsePD['result'][0]);
    return placeDetail;
  }

  Future<PlaceDetailList> getAutosuggest(String text, String location) async {
    var responsePD = await networkApiService.getApi(
        '${AppUrl.autosuggestUrl}?key=${Secrets.MAP4D_API_KEY}&text=$text&location=$location');
    PlaceDetailList placeDetailList =
        PlaceDetailList.fromJson(responsePD['result']);
    return placeDetailList;
  }
}
