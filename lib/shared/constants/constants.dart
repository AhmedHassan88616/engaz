import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

const remoteBaseURL = 'https://sae-marketing.com/mlbet/';

const baseURL = remoteBaseURL;

String? accessToken;
bool isLoggedIn = false;
bool isTabletDevice = false;
String viewType = '3d';
const viewTypeKey = 'view_type';
const langCodeKey = 'lang';
const countryIdKey = 'country';

bool isWhiteSpacesWord(String value) {
  if (value.isEmpty) return false;
  value = value.trim();
  debugPrint('value: ${value.length}');
  return value.isEmpty;
}

navigateTo({
  required context,
  required Widget screen,
}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => screen,
    ),
  );
}

navigateAndFinishTo({
  required context,
  required Widget screen,
  Function? then,
}) {
  Navigator.of(context)
      .pushReplacement(
        MaterialPageRoute(
          builder: (_) => screen,
        ),
      )
      .then((value) => then);
}

showToast({
  required String message,
  required ToastStates state,
}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 18.0);
}

chooseToastColor(ToastStates state) {
  switch (state) {
    case ToastStates.SUCCESS:
      return Colors.green;
    case ToastStates.FAILED:
      return Colors.red;
    case ToastStates.WARNING:
      return Colors.amber;
  }
}

// Toasts enum
enum ToastStates { SUCCESS, FAILED, WARNING }

getErrorMessage(error) {
  if (error is DioError && error.error is SocketException) {
    return 'no Internet Connection';
  } else if (error is HttpException) {
    return error.message;
  } else if (error is FormatException) {
    return error.message;
  } else if (error is PermissionDeniedException) {
    return error.message;
  } else {
    return 'there Is An Error';
  }
}

showErrorToast({required error}) {
  showToast(message: getErrorMessage(error), state: ToastStates.FAILED);
}

showSuccessToast({required String successMessage}) {
  showToast(message: successMessage, state: ToastStates.SUCCESS);
}

showLoadingToast() {
  showToast(message: 'loading...', state: ToastStates.WARNING);
}

void showNetworkImageDialog(context,
    {required String imageTitle, required String imageURL}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: SimpleDialog(
          title: Center(child: Text(imageTitle)),
          children: [
            Image.network(
              imageURL,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => Container(
                height: 100.0,
                width: 100.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    },
  );
}
