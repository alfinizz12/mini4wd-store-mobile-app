import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          SizedBox(height: 20),
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
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}


