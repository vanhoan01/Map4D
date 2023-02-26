// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';
import 'package:map4dmap/model/model/PlaceDetail.dart';

class SuggestionChooseItem extends StatelessWidget {
  const SuggestionChooseItem(
      {super.key, required this.placeDetail, required this.location});
  final PlaceDetail placeDetail;
  final MFLatLng location;

  @override
  Widget build(BuildContext context) {
    double x1 = placeDetail.location.lat;
    double y1 = placeDetail.location.lng;
    double x2 = location.latitude;
    double y2 = location.longitude;
    double distance = sqrt(pow((x2 - x1), 2) + pow((y2 - y1), 2)) * 111;
    return InkWell(
      onTap: () => Navigator.pop(context, placeDetail),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 24,
                    ),
                    Text(
                      '${distance.toStringAsFixed(2)}km',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      placeDetail.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      placeDetail.address,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 50,
                child: Icon(
                  Icons.north_west,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 1,
              width: MediaQuery.of(context).size.width - 70,
              color: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }
}
