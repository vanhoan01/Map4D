import 'package:flutter/material.dart';
import 'package:map4dmap/view/screens/Home.dart';

void main() {
  runApp(const MapsDemo());
}

class MapsDemo extends StatefulWidget {
  const MapsDemo({super.key});

  @override
  State<MapsDemo> createState() => MapsDemoState();
}

class MapsDemoState extends State<MapsDemo> {
  Widget page = const Home();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Map4D',
      theme: ThemeData(
        fontFamily: 'OpenSans',
        primaryColor: const Color(0xFF4285F4),
      ),
      // home: page,
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => page,
        // When navigating to the "/second" route, build the SecondScreen widget.
        // locationGeolocator.routeName: (context) => const locationGeolocator(),
      },
    );
  }
}
