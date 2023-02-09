// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MenuOverlayScreen extends StatefulWidget {
  const MenuOverlayScreen({super.key});

  @override
  State<MenuOverlayScreen> createState() => _MenuOverlayScreenState();
}

class _MenuOverlayScreenState extends State<MenuOverlayScreen> {
  final List<ListTile> _allPages = <ListTile>[
    const ListTile(
      leading: Icon(Icons.person_outline),
      title: Text("Bật chế độ ẩn danh"),
    ),
    const ListTile(
      leading: Icon(Icons.person_outline),
      title: Text("Hồ  sơ của bạn"),
    ),
    const ListTile(
      leading: Icon(Icons.timeline),
      title: Text("Dòng thời gian của bạn"),
    ),
    const ListTile(
      leading: Icon(Icons.share_location_outlined),
      title: Text("Chia sẻ vị trí"),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
          padding: const EdgeInsets.all(15.0),
          child: ListView.builder(
            itemCount: _allPages.length,
            itemBuilder: (BuildContext context, int index) {
              return _allPages[index];
            },
          ),
        ),
      ),
    );
  }
}
