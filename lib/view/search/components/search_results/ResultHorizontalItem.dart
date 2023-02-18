// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:map4dmap/model/model/PlaceDetail.dart';
import 'package:map4dmap/resources/types/place_types.dart';
import 'package:map4dmap/view/directions/DirectionsRendererScreen.dart';

class ResultHorizontalItem extends StatelessWidget {
  const ResultHorizontalItem({super.key, required this.placeDetail});
  final PlaceDetail placeDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: MediaQuery.of(context).size.width - 60,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Text(
            placeDetail.name,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(height: 10),
          Text(
            PlaceTypes.types[placeDetail.types[0]] == null
                ? "Điểm"
                : PlaceTypes.types[placeDetail.types[0]]!,
            style: const TextStyle(
                fontSize: 15, color: Color.fromRGBO(117, 117, 117, 1)),
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
                  placeDetail.address,
                  style: const TextStyle(
                      fontSize: 14, color: Color.fromRGBO(66, 66, 66, 1)),
                  maxLines: 2,
                ),
              ),
            ],
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
        ],
      ),
    );
  }
}
