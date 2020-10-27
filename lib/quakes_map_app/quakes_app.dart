import 'dart:async';
import "package:flutter/material.dart";
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quakes_app/quakes_map_app/model/quake.dart';
import 'package:quakes_app/quakes_map_app/network/network.dart';
import "package:google_maps_flutter/google_maps_flutter.dart";

class QuakesApp extends StatefulWidget {
  @override
  _QuakesAppState createState() => _QuakesAppState();
}

class _QuakesAppState extends State<QuakesApp> {
  Future<Quake> _quakesData;
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> _markerList = <Marker>[];

  @override
  void initState() {
    super.initState();
    _quakesData = Network().getAllQuakes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [_buildGoogleMap(context)],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: findQuakes, label: Text("Find Quakes")),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GoogleMap(
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        initialCameraPosition:
            CameraPosition(target: LatLng(52.5290812, 13.3250589), zoom: 3),
        markers: Set<Marker>.of(_markerList),
      ),
    );
  }

  findQuakes() {
    setState(() {
      _markerList.clear();
      _handleResponse();
    });
  }

  void _handleResponse() {
    setState(() {
      _quakesData.then((data) => {
            data.features.forEach((element) {
              _markerList.add(Marker(
                  markerId: MarkerId(element.id),
                  infoWindow:
                      InfoWindow(
                          title: element.properties.mag.toString(),
                          snippet: element.properties.title),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                  position: LatLng(element.geometry.coordinates[1],
                      element.geometry.coordinates[0]),
                  onTap: () {}));
            })
          });
    });
  }
}
