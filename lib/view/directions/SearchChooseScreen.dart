// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';
import 'package:map4dmap/model/model/PlaceDetail.dart';
import 'package:map4dmap/view/directions/compoments/SuggestionChooseItem.dart';
import 'package:map4dmap/view/search/components/Search.dart';
import 'package:map4dmap/view_model/PlaceDetailListViewModel.dart';

class SearchChooseScreen extends SearchDelegateWidget {
  MFLatLng location;
  String addressType;
  SearchChooseScreen(
      {required this.location,
      required this.addressType,
      super.searchFieldLabel,
      super.searchFieldStyle});
  PlaceDetailListViewModel placeDetailListViewModel =
      PlaceDetailListViewModel();

  // Demo list to show querying
  List<PlaceDetail> placeSearchTerms = [];
  List<PlaceDetail> placeSuggestionList = [];

  void getPlaceSuggestList(String text, String location) async {
    placeSuggestionList =
        await placeDetailListViewModel.getAutosuggest(text, location);
  }

  void getPlaceResultsList(String text, String location) async {
    placeSearchTerms =
        await placeDetailListViewModel.getTextSearch(text, location);
  }

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 15),
        child: IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear, color: Colors.black),
        ),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
    );
  }

  @override
  PreferredSizeWidget? buildBottom(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(35),
      child: InkWell(
        onTap: () {
          close(context, 'choosePossition');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              SizedBox(
                width: 70,
                child: Icon(
                  Icons.location_on_outlined,
                  size: 24,
                ),
              ),
              Expanded(
                child: Text(
                  'Chọn trên bản đồ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    if (query.trim() != "") {
      getPlaceSuggestList(
          query.trim(), '${location.latitude},${location.longitude}');
    }
    return ListView.builder(
      itemCount: placeSuggestionList.length,
      itemBuilder: (context, index) {
        var result = placeSuggestionList[index];
        return SuggestionChooseItem(
          placeDetail: result,
          location: location,
        );
      },
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim() != "") {
      getPlaceSuggestList(
          query.trim(), '${location.latitude},${location.longitude}');
    }
    return ListView.builder(
      itemCount: placeSuggestionList.length,
      itemBuilder: (context, index) {
        var result = placeSuggestionList[index];
        return SuggestionChooseItem(
          placeDetail: result,
          location: location,
        );
      },
    );
  }

  // void _navigateAndChoose(BuildContext context, String addressType) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) =>
  //           ChooseLocationScreen(choose: 'start', context: context),
  //     ),
  //   ).then((results) {
  //     if (results != null) {
  //       Navigator.of(results[0]).pop(["MFLatLng", results[1]]);
  //     }
  //   });
  // }
}
