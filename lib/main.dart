import 'package:flutter/material.dart';
import 'package:map4dmap/view/pages/locationGeolocator.dart';
import 'package:map4dmap/view/pages/locationLocation.dart';
import 'package:map4dmap/view/pages/locationMap4d.dart';
import 'package:map4dmap/view/pages/notificationPage.dart';
import 'package:map4dmap/view/screens/MenuOverlayScreen.dart';
import 'package:map4dmap/view/screens/SearchDelegateScreen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MapsDemo(),
  ));
}

class MapsDemo extends StatefulWidget {
  const MapsDemo({super.key});

  @override
  State<MapsDemo> createState() => MapsDemoState();
}

class MapsDemoState extends State<MapsDemo>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    locationGeolocator(),
    locationMap4d(),
    locationLocation(),
    notificationPage()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 68,
        automaticallyImplyLeading: false,
        leadingWidth: 47,
        actions: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 17),
            child: SizedBox(
              width: 30,
              child: Image(
                image: AssetImage('assets/google-maps.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                showSearch(
                  context: context,
                  delegate: SearchDelegateScreen(),
                );
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "Tìm kiếm ở đây",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 17),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const MenuOverlayScreen(),
                );
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 17,
                child: ClipOval(
                  child: Image(
                    image: AssetImage('assets/onion.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ],
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 39, right: 8, left: 8, bottom: 8),
          child: Container(
            decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(224, 224, 224, 1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Geolocator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.time_to_leave),
            label: 'API Google',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            label: 'Google Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Thông tin',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
