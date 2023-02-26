// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:map4dmap/model/model/PlaceDetail.dart';
import 'package:map4dmap/view/search/components/search_results/ResultHorizontalItem.dart';

class BottomPlaceListHorizontal extends StatefulWidget {
  const BottomPlaceListHorizontal(
      {super.key, required this.placeDetailList, required this.idSrcoll});
  final List<PlaceDetail>? placeDetailList;
  final String idSrcoll;

  @override
  State<BottomPlaceListHorizontal> createState() =>
      _BottomPlaceListHorizontalState();
}

class _BottomPlaceListHorizontalState extends State<BottomPlaceListHorizontal> {
  @override
  void initState() {
    super.initState();
    if (GlobalObjectKey(widget.idSrcoll).currentContext != null) {
      Scrollable.ensureVisible(
        GlobalObjectKey(widget.idSrcoll).currentContext!,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      child: Container(
        height: 190,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0;
                  i <=
                      (widget.placeDetailList!.length > 15
                          ? 15
                          : widget.placeDetailList!.length);
                  i++)
                Row(
                  key: GlobalObjectKey(widget.placeDetailList![i].id),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 10),
                    ResultHorizontalItem(
                        placeDetail: widget.placeDetailList![i]),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
