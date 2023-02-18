// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:map4dmap/model/model/PlaceDetail.dart';
import 'package:map4dmap/view/search/components/search_results/ResultHorizontalItem.dart';

class BottomPlaceListHorizontal extends StatelessWidget {
  const BottomPlaceListHorizontal({super.key, required this.placeDetailList});
  final List<PlaceDetail>? placeDetailList;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      child: Container(
        height: 190,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (var i = 0;
                i <=
                    (placeDetailList!.length > 15
                        ? 15
                        : placeDetailList!.length);
                i++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 10),
                  ResultHorizontalItem(placeDetail: placeDetailList![i]),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
