import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

import '../../data_layer/models/place_model.dart';
import '../../data_layer/sevices/google_maps_sevice.dart';

part 'google_map_state.dart';

class GoogleMapCubit extends Cubit<GoogleMapState> {
  GoogleMapCubit() : super(GoogleMapInitial());

  static BuildContext? cubitContext;

  static GoogleMapCubit get(context, {bool listen = false}) {
    cubitContext = context;
    return BlocProvider.of(context, listen: listen);
  }

  Completer<GoogleMapController> completer = Completer<GoogleMapController>();

  // google maps part
  Set<Marker> markers = {};
  GoogleMapController? mapController;
  CameraPosition initialLocation =
      const CameraPosition(target: LatLng(0.0, 0.0), tilt: 20.0);
  LatLng? currentLocation;

  Future<bool> checkLocationPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return false;
      }
    }
    return true;
  }

  getCurrentLocation() async {
    checkLocationPermission().then((value) {
      if (value) {
        emit(GetCurrentLocationDataLoadingState());
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
            .then((value) {
          currentLocation = LatLng(value.latitude, value.longitude);

          animateCameraToPosition(currentLocation!);

          GoogleMapsService.addMapMarker(
            markers: markers,
            markerId: 'you',
            position: currentLocation!,
            markerTitle: 'you',
          );

          emit(GetCurrentLocationDataSuccessState());
        }).catchError((error) {
          debugPrint('$error');
          emit(GetCurrentLocationDataErrorState());
        });
      }
    }).catchError((error) {
      debugPrint('$error');
    });
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle("[]");
    if (!completer.isCompleted) completer.complete(controller);
    mapController = controller;
  }

  void prepareMap(List<PlaceModel> places) {
    checkLocationPermission().then((value) {
      if (value) {
        markers.removeWhere((element) => element.markerId.value != 'you');
        if (places.isEmpty) return;
        for (int index = 0; index < places.length; index++) {
          GoogleMapsService.addMapMarker(
            markers: markers,
            markerId: places[index].placesID ?? ' ',
            position: LatLng(double.tryParse(places[index].lat!) ?? 0.0,
                double.tryParse(places[index].longt!) ?? 0.0),
            markerTitle: places[index].placeName ?? ' ',
            onTap: () {
              animateAndShowLabel(places[index])
                  .then((value) => _shoBottomSheet(places[index]));
            },
          );
        }

        // Calculating to check that the position relative
        // to the frame, and pan & zoom the camera accordingly.

        double startLatitude = 0.0;
        double startLongitude = 0.0;
        double destinationLatitude = 0.0;
        double destinationLongitude = 0.0;
        if (places.isNotEmpty) {
          startLatitude = double.tryParse(places[0].lat!) ?? 0.0;
          startLongitude =
              double.tryParse(places[places.length - 1].longt!) ?? 0.0;
          destinationLatitude =
              double.tryParse(places[places.length - 1].lat!) ?? 0.0;
          destinationLongitude =
              double.tryParse(places[places.length - 1].longt!) ?? 0.0;
        }

        double miny = (startLatitude <= destinationLatitude)
            ? startLatitude
            : destinationLatitude;
        double minx = (startLongitude <= destinationLongitude)
            ? startLongitude
            : destinationLongitude;
        double maxy = (startLatitude <= destinationLatitude)
            ? destinationLatitude
            : startLatitude;
        double maxx = (startLongitude <= destinationLongitude)
            ? destinationLongitude
            : startLongitude;

        double southWestLatitude = miny;
        double southWestLongitude = minx;

        double northEastLatitude = maxy;
        double northEastLongitude = maxx;

        // Accommodate the two locations within the
        // camera view of the map
        mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(northEastLatitude, northEastLongitude),
              southwest: LatLng(southWestLatitude, southWestLongitude),
            ),
            100.0,
          ),
        );
      }
      emit(PrepareMapSuccessState());
    }).catchError((error) {
      debugPrint('$error');
    });
  }

  Future animateCameraToPosition(LatLng position) async {
    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 16.0,
        ),
      ),
    );
  }

  Future animateAndShowLabel(PlaceModel place) async {
    await animateCameraToPosition(
      LatLng(
        double.tryParse(place.lat ?? '0.0')!,
        double.tryParse(place.longt ?? '0.0')!,
      ),
    );
    mapController!.showMarkerInfoWindow(MarkerId(
      place.placeName.toString(),
    ));
    await Future.delayed(const Duration(milliseconds: 1300));
  }

  void _shoBottomSheet(PlaceModel place) async {
    await showModalBottomSheet(
        context: cubitContext!,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        backgroundColor: Colors.white,
        isDismissible: false,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(cubitContext!).size.height * 0.45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: const EdgeInsets.all(15.0),
                    color: Colors.grey,
                    child: Image.network(
                      place.photo ?? ' ',
                      fit: BoxFit.fill,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
