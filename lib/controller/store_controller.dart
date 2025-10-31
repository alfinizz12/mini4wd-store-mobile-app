import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/controller/location_controller.dart';
import 'package:mini4wd_store/model/store.dart';
import 'package:mini4wd_store/service/api/store_api_service.dart';

class StoreController extends GetxController {
  final StoreApiService _storeService = StoreApiService();

  final RxList<Store> stores = <Store>[].obs;
  final LocationController _locationController = Get.find<LocationController>();

  @override
  void onInit(){
    getAllStores();
    super.onInit();
  }

  Future<void> getAllStores() async {
    final result = await _storeService.getAllStore();
    stores.value = result;
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
}