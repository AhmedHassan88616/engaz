import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsService {
  // Method for retrieving the current location
  static getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      //  print('CURRENT POS: ${provider.currentLatLng}');
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print(e);
    }
  }

  static addMapMarker({
    required Set<Marker> markers,
    required String markerId,
    required LatLng position,
    required markerTitle,
    Function? onTap,
  }) async {
    // Start Location Marker
    Marker marker = Marker(
      onTap: () {
        if (onTap != null) onTap();
      },
      markerId: MarkerId(markerId),
      position: LatLng(position.latitude, position.longitude),
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: markerTitle,
      ),
    );
    // Adding the markers to the list
    markers.add(marker);
  }

  // Method for calculating the distance between two places
  static double calculateDistanceInMeters(
      LatLng startCoordinates, LatLng destinationCoordinates) {
    double totalDistance = 0.0;
    try {
      // print('START COORDINATES: $startCoordinates');
      // print('DESTINATION COORDINATES: $destinationCoordinates');

      LatLng _northeastCoordinates;
      LatLng _southwestCoordinates;

      totalDistance = _coordinateDistance(
        startCoordinates.latitude,
        startCoordinates.longitude,
        destinationCoordinates.latitude,
        destinationCoordinates.longitude,
      );
    } catch (e) {
      print(e);
    }
    return totalDistance;
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  static double _coordinateDistance(
    lat1,
    lon1,
    lat2,
    lon2,
  ) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
    // return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000.0;
  }
}
