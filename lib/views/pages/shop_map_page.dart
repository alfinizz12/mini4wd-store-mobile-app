import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mini4wd_store/controller/location_controller.dart';
import 'package:mini4wd_store/controller/store_controller.dart';
import 'package:mini4wd_store/ui/components/location_info.dart';
import 'package:mini4wd_store/ui/components/store_location_list.dart';

class ShopMapPage extends StatefulWidget {
  const ShopMapPage({super.key});

  @override
  State<ShopMapPage> createState() => _ShopMapPageState();
}

class _ShopMapPageState extends State<ShopMapPage> {
  final StoreController _storeController = Get.find<StoreController>();
  final LocationController _locationController = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Text(
            "Find store and community around you!",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          // Map
          Obx(() {
            final pos = _locationController.location.value;
            if (pos == null) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            // Daftar toko
            final stores = _storeController.stores;
            if (stores.isEmpty) {
              return const SizedBox(
                height: 200,
                child: Center(child: Text("Loading map...")),
              );
            }

            // Marker posisi user + toko-toko
            final markers = <Marker>[
              Marker(
                width: 40,
                height: 40,
                point: LatLng(pos.latitude, pos.longitude),
                child: const Icon(
                  Icons.person_pin_circle,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
              ...stores.map((store) {
                return Marker(
                  width: 40,
                  height: 40,
                  point: LatLng(store.latitude, store.longitude),
                  child: const Icon(
                    Icons.store,
                    color: Colors.red,
                    size: 35,
                  ),
                );
              }),
            ];

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 250,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(pos.latitude, pos.longitude),
                    initialZoom: 13,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.mini4wd_store',
                    ),
                    MarkerLayer(markers: markers),
                  ],
                ),
              ),
            );
          }),

          Obx(() {
            final pos = _locationController.location.value;
            final msg = _locationController.statusMessage.value;

            if (pos == null) {
              return Text(msg.isEmpty ? "Getting Location..." : msg);
            }

            return LocationInfo(pos: pos, msg: msg);
          }),

          Expanded(
            child: Obx(() {
              if (_storeController.stores.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.separated(
                itemCount: _storeController.stores.length,
                itemBuilder: (context, index) {
                  return StoreLocationList(
                    store: _storeController.stores[index],
                    storeController: _storeController,
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 10),
              );
            }),
          ),
        ],
      ),
    );
  }
}
