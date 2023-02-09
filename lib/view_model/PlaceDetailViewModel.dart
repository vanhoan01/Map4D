import 'package:map4dmap/data/network_api_services.dart';
import 'package:map4dmap/model/model/PlaceDetail.dart';
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
}
