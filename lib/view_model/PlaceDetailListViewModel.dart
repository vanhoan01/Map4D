// ignore_for_file: file_names

import 'package:map4dmap/data/network_api_services.dart';
import 'package:map4dmap/model/model/PlaceDetail.dart';
import 'package:map4dmap/model/modelList/PlaceDetailList.dart';
import 'package:map4dmap/resources/app_urls.dart';
import 'package:map4dmap/resources/secrets.dart';

class PlaceDetailListViewModel {
  NetworkApiService networkApiService = NetworkApiService();

  Future<List<PlaceDetail>> getAutosuggest(String text, String location) async {
    List<PlaceDetail> data = [];
    try {
      var responsePD = await networkApiService.getApi(
          '${AppUrl.autosuggestUrl}?key=${Secrets.MAP4D_API_KEY}&text=$text&location=$location');
      print('responsePD[result]: ${responsePD['result']}');
      PlaceDetailList placeDetailList =
          PlaceDetailList.fromJson({'data': responsePD['result']});
      print('placeDetailList: ${placeDetailList.data![0].name}');
      data = placeDetailList.data!;
    } catch (e) {
      print(e);
    }
    return data;
  }

  Future<List<PlaceDetail>> getTextSearch(String text, String location) async {
    List<PlaceDetail> data = [];
    try {
      var responsePD = await networkApiService.getApi(
          '${AppUrl.textSearchUrl}?key=${Secrets.MAP4D_API_KEY}&text=$text&location=$location');
      print('responsePD[result]: ${responsePD['result']}');
      PlaceDetailList placeDetailList =
          PlaceDetailList.fromJson({'data': responsePD['result']});
      print('placeDetailList: ${placeDetailList.data![0].name}');
      data = placeDetailList.data!;
    } catch (e) {
      print(e);
    }
    return data;
  }
}
