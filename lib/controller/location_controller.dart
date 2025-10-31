import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mini4wd_store/service/location_service.dart';

class LocationController extends GetxController {
  final LocationService _locationService = LocationService();

  final Rx<Position?> location = Rx<Position?>(null);

  final RxString statusMessage = ''.obs;

  Stream<Position>? _positionStream;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    startLocationStream();
  }

  Future<void> getCurrentLocation() async {
    try {
      final pos = await _locationService.determinePosition();
      location.value = pos;
      statusMessage.value = "Get location success!";
    } catch (e) {
      statusMessage.value = "Failed while getting location";
    }
  }

  void startLocationStream() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    );

    _positionStream!.listen((Position pos) {
      location.value = pos;
      statusMessage.value =
          "${pos.latitude}, ${pos.longitude}";
    });
  }

  void stopLocationStream() {
    _positionStream = null;
  }
}
