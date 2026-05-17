import 'dart:math' as Math;

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:wasla/core/service/maps/models/places_model.dart';

abstract class MapServices {
  static final Dio dio = Dio();
  static Future<Either<String, LocationData>> getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return left("Location service is disabled,please enable it");
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return left("Location permission is denied");
      }
    }
    locationData = await location.getLocation();
    return right(locationData);
  }

  static Future<Either<String, String>> getCityFromLatLng(
    double lat,
    double lng,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks.first;

      final String city =
          place.locality ?? place.subAdministrativeArea ?? 'Unknown';

      return right(city);
    } catch (e) {
      return left('Error: City Not Found');
    }
  }

  static Future<List<PlaceModel>> searchPlaces(String query) async {
  if (query.trim().isEmpty) return [];

  try {
    final response = await dio.get(
      'https://api.geoapify.com/v1/geocode/autocomplete',
      queryParameters: {
        'text': query,
        'limit': 5,
        'apiKey': '8a39a2db214a422cac8b556e3adbda20',
      },
    );

    return (response.data['features'] as List)
        .map((e) => PlaceModel.fromGeoapify(e))
        .toList();
  } catch (e) {
    print(e.toString());
    return [];
  }
}

  static Future<List<LatLng>> getBestRoute({
    required LatLng start,
    required LatLng end,
  }) async {
    final url =
        "https://router.project-osrm.org/route/v1/driving/"
        "${start.longitude},${start.latitude};"
        "${end.longitude},${end.latitude}"
        "?overview=full&geometries=geojson";

    final response = await dio.get(url);

    final List coordinates =
        response.data["routes"][0]["geometry"]["coordinates"];

    List<LatLng> routePoints = coordinates.map<LatLng>((point) {
      return LatLng(point[1], point[0]);
    }).toList();

    // log('routePoints: $routePoints');

    return routePoints;
  }

  static List<LatLng> interpolatePoints(LatLng start, LatLng end, int steps) {
    List<LatLng> points = [];
    double latStep = (end.latitude - start.latitude) / steps;
    double lngStep = (end.longitude - start.longitude) / steps;

    for (int i = 0; i <= steps; i++) {
      points.add(
        LatLng(start.latitude + (latStep * i), start.longitude + (lngStep * i)),
      );
    }

    return points;
  }

  static double calculateBearing(LatLng start, LatLng end) {
    double lat1 = start.latitude * (3.14159265359 / 180);
    double lon1 = start.longitude * (3.14159265359 / 180);
    double lat2 = end.latitude * (3.14159265359 / 180);
    double lon2 = end.longitude * (3.14159265359 / 180);

    double dLon = lon2 - lon1;

    double y = Math.sin(dLon) * Math.cos(lat2);
    double x =
        Math.cos(lat1) * Math.sin(lat2) -
        Math.sin(lat1) * Math.cos(lat2) * Math.cos(dLon);

    double bearing = Math.atan2(y, x) * (180 / 3.14159265359);

    return (bearing + 360) % 360;
  }
}
