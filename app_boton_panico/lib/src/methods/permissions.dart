import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// This class is used to check if the user has enabled location services and if the user has granted
/// location permissions
class Permissions {
  /// If the user has denied location permissions, we can't ask for them again
  /// 
  /// Args:
  ///   context: The context of the widget that is calling the function.
  /// 
  /// Returns:
  ///   A Future<bool>
  static Future<bool> handleLocationPermission(context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Los servicos de localización estan deshabilitados, Por favor habilite lo servicios')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Permisos de localización han sido denegados.')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Los permisos de localización están permanentemente denegados, no podemos solicitar permisos.')));
      return false;
    }
    return true;
  }
}
