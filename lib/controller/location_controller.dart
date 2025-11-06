import 'dart:async';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mini4wd_store/service/location_service.dart';
import 'package:mini4wd_store/service/notification_service.dart';

class LocationController extends GetxController {
  final LocationService _locationService = LocationService();
  final NotificationService _notificationService = NotificationService();

  final Rx<Position?> location = Rx<Position?>(null);
  final RxString statusMessage = ''.obs;

  StreamSubscription<Position>? _positionSubscription;
  Position? _lastPosition;
  Position? _lastNotifiedPosition;

  final double notifyThreshold = 500; // meter
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _notificationService.initNotification();
    _loadLastNotifiedPosition();
    getCurrentLocation();
    startLocationStream();
  }

  // 🟢 Tambahan: dipanggil setiap kali controller aktif lagi
  @override
  void onReady() {
    super.onReady();
    // Jika stream belum aktif (misal setelah logout dan login lagi), hidupkan ulang
    if (_positionSubscription == null) {
      getCurrentLocation();
      startLocationStream();
    }
  }

  Future<void> _loadLastNotifiedPosition() async {
    await GetStorage.init();
    final lat = box.read('lastNotifiedLat');
    final lon = box.read('lastNotifiedLon');
    if (lat != null && lon != null) {
      _lastNotifiedPosition = Position(
        latitude: lat,
        longitude: lon,
        timestamp: DateTime.now(),
        accuracy: 10,
        altitude: 100,
        altitudeAccuracy: 5,
        heading: 0,
        headingAccuracy: 1,
        speed: 0,
        speedAccuracy: 0,
      );
    }
  }

  Future<void> _saveLastNotifiedPosition(Position pos) async {
    box.write('lastNotifiedLat', pos.latitude);
    box.write('lastNotifiedLon', pos.longitude);
  }

  Future<void> getCurrentLocation() async {
    try {
      final pos = await _locationService.determinePosition();
      location.value = pos;
      _lastPosition = pos;
      await _showLocationNotificationIfNeeded(pos);
      statusMessage.value = "Get location success!";
    } catch (e) {
      statusMessage.value = "Failed while getting location";
    }
  }

  void startLocationStream() {
    stopLocationStream(); // pastikan tidak ada listener ganda

    final stream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 20,
      ),
    );

    _positionSubscription = stream.listen((Position pos) async {
      location.value = pos;
      statusMessage.value = "${pos.latitude}, ${pos.longitude}";
      await _showLocationNotificationIfNeeded(pos);
      _lastPosition = pos;
    });
  }

  Future<void> _showLocationNotificationIfNeeded(Position pos) async {
    if (_lastNotifiedPosition == null) {
      _lastNotifiedPosition = pos;
      await _saveLastNotifiedPosition(pos);
      await _notificationService.showNotification(
        title: "Location Detected",
        body:
            "You are around (${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)})",
      );
      return;
    }

    final distance = Geolocator.distanceBetween(
      _lastNotifiedPosition!.latitude,
      _lastNotifiedPosition!.longitude,
      pos.latitude,
      pos.longitude,
    );

    if (distance > notifyThreshold) {
      _lastNotifiedPosition = pos;
      await _saveLastNotifiedPosition(pos);
      await _notificationService.showNotification(
        title: "New Location Detected",
        body:
            "You moved to around (${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)})",
      );
    }
  }

  void stopLocationStream() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  @override
  void onClose() {
    stopLocationStream();
    super.onClose();
  }
}
