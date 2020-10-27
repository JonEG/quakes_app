import "package:flutter/material.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";

class ShowSimpleMap extends StatefulWidget {
  @override
  _ShowSimpleMapState createState() => _ShowSimpleMapState();
}

class _ShowSimpleMapState extends State<ShowSimpleMap> {
  GoogleMapController mapController;

  static final LatLng berlin = const LatLng(52.516856, 13.406853);
  static final LatLng moabit = const LatLng(52.5290812, 13.3250589);

  static final CameraPosition ovanPosition = CameraPosition(
      target: LatLng(52.5232326, 13.3141584), zoom: 14.780, bearing: 40);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Maps"),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: berlin,
          zoom: 11,
        ),
        markers: {berlinMarker, moabitMarker},
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 45.0),
        child: FloatingActionButton.extended(
          onPressed: _goToOvanGbH,
          label: Text("OvanGbH"),
          icon: Icon(Icons.place),
        ),
      ),
    );
  }

  Future<void> _goToOvanGbH() async {
    final googleMapController = await mapController;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(ovanPosition));
  }

  Marker berlinMarker = Marker(
      markerId: MarkerId("Berlin"),
      position: berlin,
      infoWindow: InfoWindow(title: "Berlin", snippet: "Mitte"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta));

  Marker moabitMarker = Marker(
      markerId: MarkerId("Moabit"),
      position: moabit,
      infoWindow: InfoWindow(title: "Berlin", snippet: "HEHEE"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta));
}
