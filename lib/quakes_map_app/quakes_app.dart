import 'dart:async';
import "package:flutter/material.dart";
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quakes_app/quakes_map_app/model/quake.dart';
import 'package:quakes_app/quakes_map_app/network/network.dart';
import 'package:geodesy/geodesy.dart' as MyGeodesy;

class QuakesApp extends StatefulWidget {
  @override
  _QuakesAppState createState() => _QuakesAppState();
}

class _QuakesAppState extends State<QuakesApp> {
  Future<Quake> _quakesData;
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> _markerList = <Marker>[];
  double _zoomVal = 3.0;
  LatLng dartLatMiddlePoint = LatLng(52.5290812, 13.3250589);

  @override
  void initState() {
    super.initState();
    _quakesData = Network().getAllQuakes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [_buildGoogleMap(context), _zoomMinus(), _zoomPlus()],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: findQuakes, label: Text("Find Quakes")),
    );
  }

  Widget _zoomMinus() {
    return Padding(
      padding: const EdgeInsets.only(top: 28.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
            icon: Icon(
              MaterialCommunityIcons.magnify_minus,
              color: Colors.black87,
            ),
            onPressed: () {
              setState(() {
                _zoomVal--;
              });
              _updateZoom(_zoomVal);
            }),
      ),
    );
  }

  Widget _zoomPlus() {
    return Padding(
      padding: const EdgeInsets.only(top: 28.0),
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
            icon: Icon(
              MaterialCommunityIcons.magnify_plus,
              color: Colors.black87,
            ),
            onPressed: () {
              setState(() {
                _zoomVal++;
              });
              _updateZoom(_zoomVal);
            }),
      ),
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
        initialCameraPosition: CameraPosition(
            target: dartLatMiddlePoint, zoom: _zoomVal),
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
                  infoWindow: InfoWindow(
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

  Future<void> _updateZoom(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.getVisibleRegion().then((value) {
      //GET MAP CENTER
      MyGeodesy.LatLng l1 =
          MyGeodesy.LatLng(value.northeast.latitude, value.northeast.longitude);
      MyGeodesy.LatLng l2 =
          MyGeodesy.LatLng(value.southwest.latitude, value.southwest.longitude);
      var geoLatMiddlePoint =
          MyGeodesy.Geodesy().midPointBetweenTwoGeoPoints(l1, l2);
      setState(() {
        dartLatMiddlePoint =
            LatLng(geoLatMiddlePoint.latitude, geoLatMiddlePoint.longitude);
        print("CAMERA SHOULD GO: $dartLatMiddlePoint");
      });

      //CAMERA ZOOMS
      print("CAMERA GOES: $dartLatMiddlePoint");
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: dartLatMiddlePoint, zoom: zoomVal)));
    });
  }
}
