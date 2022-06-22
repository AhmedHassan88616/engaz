import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/business_logic_layer/google_map_cubit/google_map_cubit.dart';
import 'package:map_app/business_logic_layer/places_cubit/places_cubit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final GoogleMapCubit _googleMapCubit;
  late final PlacesCubit _placesCubit;

  @override
  void initState() {
    _googleMapCubit = GoogleMapCubit.get(context);
    _placesCubit = PlacesCubit.get(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Places'),
        centerTitle: true,
      ),
      body: BlocConsumer<PlacesCubit, PlacesState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is GetPlacesDataSuccessState) {
            _googleMapCubit.prepareMap(_placesCubit.places);
          }
        },
        builder: (context, state) {
          return BlocConsumer<GoogleMapCubit, GoogleMapState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, googleMapState) {
              return Stack(
                children: [
                  GoogleMap(
                    markers: _googleMapCubit.markers,
                    initialCameraPosition: _googleMapCubit.initialLocation,
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    onMapCreated: _googleMapCubit.onMapCreated,
                  ),
                  // Show zoom buttons
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ClipOval(
                            child: Material(
                              color: Colors.blue.shade100, // button color
                              child: InkWell(
                                splashColor: Colors.blue, // inkwell color
                                child: const SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Icon(Icons.add),
                                ),
                                onTap: () {
                                  _googleMapCubit.mapController?.animateCamera(
                                    CameraUpdate.zoomIn(),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ClipOval(
                            child: Material(
                              color: Colors.blue.shade100, // button color
                              child: InkWell(
                                splashColor: Colors.blue, // inkwell color
                                child: const SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Icon(Icons.remove),
                                ),
                                onTap: () {
                                  _googleMapCubit.mapController?.animateCamera(
                                    CameraUpdate.zoomOut(),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          _googleMapCubit.getCurrentLocation();
                        },
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
