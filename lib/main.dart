import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/business_logic_layer/google_map_cubit/google_map_cubit.dart';
import 'package:map_app/business_logic_layer/places_cubit/places_cubit.dart';
import 'package:map_app/presentation_layer/screens/map_screen/map_screen.dart';
import 'package:map_app/shared/bloc_observer/bloc_server.dart';
import 'package:map_app/shared/network/remote/dio_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlacesCubit>(
          create: (context) => PlacesCubit()..getUserPlaces(),
        ),
        BlocProvider<GoogleMapCubit>(
          create: (context) => GoogleMapCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Map',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MapScreen(),
      ),
    );
  }
}
