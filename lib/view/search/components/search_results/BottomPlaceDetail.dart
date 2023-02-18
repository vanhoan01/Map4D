// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:map4dmap/model/model/PlaceDetail.dart';
import 'package:map4dmap/resources/types/place_types.dart';
import 'package:map4dmap/view/directions/DirectionsRendererScreen.dart';

class BottomPlaceDetail extends StatelessWidget {
  const BottomPlaceDetail({super.key, this.placeDetail});
  final PlaceDetail? placeDetail;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .18,
      minChildSize: .18,
      maxChildSize: 0.4,
      snap: true,
      snapSizes: const [0.4],
      // expand: false,
      expand: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: MediaQuery.of(context).size.height,
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
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 10),
                Text(
                  placeDetail!.name,
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
                const SizedBox(height: 10),
                Text(
                  PlaceTypes.types[placeDetail!.types[0]] == null
                      ? "Điểm"
                      : PlaceTypes.types[placeDetail!.types[0]]!,
                  style: const TextStyle(
                      fontSize: 15, color: Color.fromRGBO(117, 117, 117, 1)),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DirectionsRendererScreen(
                          destination: placeDetail,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.directions),
                  label: const Text(
                    'Đường đi',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                    backgroundColor: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 1,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.location_on_outlined,
                          color: Colors.blueAccent,
                        )),
                    Expanded(
                      child: Text(
                        placeDetail!.address,
                        style: const TextStyle(
                            fontSize: 14, color: Color.fromRGBO(66, 66, 66, 1)),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
