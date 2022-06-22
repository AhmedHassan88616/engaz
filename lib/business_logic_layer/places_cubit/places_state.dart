part of 'places_cubit.dart';

@immutable
abstract class PlacesState {}

class PlacesInitial extends PlacesState {}

class GetPlacesDataLoadingState extends PlacesState {}

class GetPlacesDataSuccessState extends PlacesState {}

class GetPlacesDataEmptyState extends PlacesState {}

class GetPlacesDataErrorState extends PlacesState {
  final error;

  GetPlacesDataErrorState({this.error});
}
