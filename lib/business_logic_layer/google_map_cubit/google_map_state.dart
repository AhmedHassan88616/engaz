part of 'google_map_cubit.dart';

@immutable
abstract class GoogleMapState {}

class GoogleMapInitial extends GoogleMapState {}

class GetCurrentLocationDataLoadingState extends GoogleMapState {}

class GetCurrentLocationDataSuccessState extends GoogleMapState {}

class GetCurrentLocationDataErrorState extends GoogleMapState {
  final error;

  GetCurrentLocationDataErrorState({this.error});
}

class CheckLocationPermissionDeniedState extends GoogleMapState {}

class CheckLocationPermissionSuccessState extends GoogleMapState {}

class PrepareMapSuccessState extends GoogleMapState {}
