// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:map4dmap/model/model/PlaceDetail.dart';
import 'package:map4dmap/view/search/components/search_results/ResultHorizontalItem.dart';
import 'package:map4dmap/view/search/components/search_results/ResultVerticalItem.dart';

class BottomPlaceListDetail extends StatelessWidget {
  const BottomPlaceListDetail({super.key, required this.placeDetailList});
  final List<PlaceDetail>? placeDetailList;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .5,
      minChildSize: .2,
      maxChildSize: 0.88,
      snap: true,
      snapSizes: const [0.5],
      // expand: false,
      expand: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10.0),
                topLeft: Radius.circular(10.0),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5.0,
                  spreadRadius: 20.0,
                  offset: const Offset(0.0, 5.0),
                  color: Colors.black.withOpacity(0.1),
                )
              ],
              color: Colors.grey.shade100,
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      height: 5,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                // ListView.builder(
                //   itemCount:
                //       placeDetailList == null ? 0 : placeDetailList!.length,
                //   itemBuilder: (BuildContext context, int index) {
                //     if (index < 15) {
                //       return Column(
                //         children: [
                //           Container(
                //             height: 10,
                //           ),
                //           ResultVerticalItem(
                //               placeDetail: placeDetailList![index]),
                //         ],
                //       );
                //     }
                //     return Container();
                //   },
                // ),
                for (var i = 0;
                    i <=
                        (placeDetailList!.length > 15
                            ? 15
                            : placeDetailList!.length);
                    i++)
                  Column(
                    children: [
                      Container(
                        height: 10,
                      ),
                      ResultVerticalItem(placeDetail: placeDetailList![i]),
                    ],
                  ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
