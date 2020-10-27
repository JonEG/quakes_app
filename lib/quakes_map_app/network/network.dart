import 'dart:convert';
import 'package:quakes_app/quakes_map_app/model/quake.dart';
import 'package:http/http.dart';

class Network {
  Future<Quake> getAllQuakes() async {
    var apiURL = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson";

    final Response response = await get(Uri.encodeFull(apiURL));

    if(response.statusCode == 200){
      //ok
      print("Quake data: ${response.body}");
      return Quake.fromJson(json.decode(response.body));
    }else{
      throw Exception("Error getting quakes");
    }
  }
}