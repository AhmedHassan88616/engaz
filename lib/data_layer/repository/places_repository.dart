import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:map_app/data_layer/endpoints/endpoints.dart';
import 'package:map_app/data_layer/models/place_model.dart';

import '../../shared/network/remote/dio_helper.dart';

class PlacesRepository {
  static final PlacesRepository _singleton = PlacesRepository._internal();

  factory PlacesRepository() {
    return _singleton;
  }

  PlacesRepository._internal();

  Future<List<PlaceModel>> getUserPlaces() async {
    const endpoint = getPlaces;
    final response = await DioHelper.getData(
      url: endpoint,
    );
    debugPrint('statusCode: ${response.statusCode}');
    debugPrint('response data: ${response.data}');
    final jsonStr = jsonDecode(response.data);
    if (jsonStr["status_code"] != 200) {
      throw const HttpException('there is an error');
    }
    List data = jsonStr['data'];
    return data.map((e) => PlaceModel.fromJson(e)).toList();
  }
}
