// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';
import 'package:map4dmap/model/model/PlaceDetail.dart';
import 'package:map4dmap/view/search/components/Search.dart';
import 'package:map4dmap/view/search/components/SuggestionItem.dart';
import 'package:map4dmap/view_model/PlaceDetailListViewModel.dart';

class SearchDelegateScreen extends SearchDelegateWidget {
  MFLatLng location;
  SearchDelegateScreen(
      {required this.location, super.searchFieldLabel, super.searchFieldStyle});
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

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    if (query.trim() != "") {
      getPlaceResultsList(
          query.trim(), '${location.latitude},${location.longitude}');
    }
    Navigator.pop(context, query.trim());
    return Container();
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
        return SuggestionItem(
          placeDetail: result,
          location: location,
        );
      },
    );
  }
}
