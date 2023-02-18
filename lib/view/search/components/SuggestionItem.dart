import 'package:flutter/material.dart';
import 'package:map4dmap/model/model/PlaceDetail.dart';
import 'package:map4dmap/view/pages/locationGeolocator.dart';

class SuggestionItem extends StatelessWidget {
  const SuggestionItem({super.key, required this.placeDetail});
  final PlaceDetail placeDetail;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                locationGeolocator(locationId: placeDetail.id)),
      ),
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
                  children: const [
                    Icon(
                      Icons.access_time,
                      size: 24,
                    ),
                    Text(
                      '300m',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
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
