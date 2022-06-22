import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/data_layer/models/place_model.dart';
import 'package:map_app/data_layer/repository/places_repository.dart';
import 'package:map_app/shared/constants/constants.dart';
import 'package:meta/meta.dart';

part 'places_state.dart';

class PlacesCubit extends Cubit<PlacesState> {
  PlacesCubit() : super(PlacesInitial());

  static PlacesCubit get(context, {bool listen = false}) =>
      BlocProvider.of(context, listen: listen);
  final PlacesRepository _placesRepository = PlacesRepository();
  final List<PlaceModel> places = [];

  getUserPlaces() {
    showLoadingToast();
    places.clear();
    emit(GetPlacesDataLoadingState());
    _placesRepository.getUserPlaces().then((value) {
      places.addAll(value);
      if (places.isEmpty) {
        emit(GetPlacesDataEmptyState());
      } else {
        emit(GetPlacesDataSuccessState());
      }
      showSuccessToast(successMessage: 'success');
    }).catchError((error) {
      debugPrint('$error');
      showErrorToast(error: error);
      emit(GetPlacesDataErrorState(error: error));
    });
  }
}
