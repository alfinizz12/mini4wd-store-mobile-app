import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/controller/location_controller.dart';
import 'package:mini4wd_store/model/store.dart';
import 'package:mini4wd_store/service/api/store_api_service.dart';
import 'package:mini4wd_store/service/notification_service.dart';

class StoreController extends GetxController {
  final StoreApiService _storeService = StoreApiService();
  final NotificationService _notificationService = NotificationService();
  final LocationController _locationController = Get.find<LocationController>();

  final RxList<Store> stores = <Store>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAllStores();

    // setiap kali lokasi berubah, cek toko terdekat
    _locationController.location.listen((pos) {
      _checkNearbyStores();
    });
  }

  Future<void> getAllStores() async {
    final result = await _storeService.getAllStore();
    stores.value = result;

    // setelah data toko didapat, langsung cek toko terdekat
    _checkNearbyStores();
  }

  double getDistanceToStore(double storeLat, double storeLng) {
    final pos = _locationController.location.value;
    if (pos == null) return 0.0;

    double distanceInMeters = Geolocator.distanceBetween(
      pos.latitude,
      pos.longitude,
      storeLat,
      storeLng,
    );

    return distanceInMeters / 1000; // km
  }

  void _checkNearbyStores() {
    final pos = _locationController.location.value;
    if (pos == null || stores.isEmpty) return;

    for (var store in stores) {
      double distance = getDistanceToStore(store.latitude, store.longitude);

      if (distance <= 2) {
        _notificationService.showNotification(
          title: "Toko Tamiya Terdekat",
          body:
              "${store.name} berada dalam jarak ${distance.toStringAsFixed(2)} km dari Anda!",
        );
      }
    }
  }

  // fungsi publik jika ingin dipanggil manual
  void checkNearbyStores() => _checkNearbyStores();
}
