import 'dart:async';

import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  final _locationActive = false.obs;
  bool get locationActive => _locationActive.value;
  set locationActive(bool value) => _locationActive.value = value;

  final _hasPermission = false.obs;
  bool get hasPermission => _hasPermission.value;
  set hasPermission(bool value) => _hasPermission.value = value;

  final _position = Rxn<Position>();
  Position? get position => _position.value;
  set position(Position? value) => _position.value = value;

  StreamSubscription<ServiceStatus>? _statusLocationSubs;
  StreamSubscription<Position>? _positionSubs;

  Stream<LocationMarkerPosition?>? positionStream;
  final Location _location = Location();

  void listenLocationStatus() {
    _statusLocationSubs = Geolocator.getServiceStatusStream().listen(
      (status) {
        // Esperar 1 segundo para que el servicio de ubicación se active
        Future.delayed(const Duration(seconds: 1), () {
          locationActive = status == ServiceStatus.enabled;
          if (locationActive && hasPermission) {
            listenLocationPosition();
          } else {
            position = null;
            _positionSubs?.cancel();
          }
        });
      },
    );
  }

  @override
  void onInit() {
    checkPermissionStatus();
    checkLocationStatus();
    listenLocationStatus();
    super.onInit();
  }

  Future<void> checkLocationStatus() async {
    final result = await Geolocator.isLocationServiceEnabled();
    locationActive = result;
    if (locationActive && hasPermission) {
      listenLocationPosition();
    } else {
      _positionSubs?.cancel();
    }
  }

  Future<void> checkPermissionStatus() async {
    final result = await _location.requestPermission();
    hasPermission = result == PermissionStatus.granted ||
        result == PermissionStatus.grantedLimited;
    if (hasPermission) {
      listenLocationPosition();
    } else {
      _positionSubs?.cancel();
    }
  }

  void listenLocationPosition() {
    _positionSubs = Geolocator.getPositionStream().listen(
      (position) {
        this.position = position;
      },
      cancelOnError: false,
      onError: (error) {},
    );
    positionStream = Geolocator.getPositionStream().map((position) {
      return LocationMarkerPosition(
        longitude: position.longitude,
        latitude: position.latitude,
        accuracy: position.accuracy,
      );
    });
  }

  void requestPermission() async {
    if (!hasPermission) {
      final result = await _location.requestPermission();
      hasPermission = result == PermissionStatus.granted ||
          result == PermissionStatus.grantedLimited;
      if (hasPermission) {
        listenLocationPosition();
      } else {
        _positionSubs?.cancel();
      }
      return;
    }
    await _location.requestService();
  }

  @override
  void onClose() {
    _statusLocationSubs?.cancel();
    _positionSubs?.cancel();
    super.onClose();
  }
}
