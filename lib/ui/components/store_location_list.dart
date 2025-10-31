import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/controller/store_controller.dart';
import 'package:mini4wd_store/model/store.dart';

class StoreLocationList extends StatelessWidget {
  const StoreLocationList({
    super.key,
    required this.store,
    required this.storeController,
  });

  final Store store;
  final StoreController storeController;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {},
        leading: Icon(Icons.location_on_outlined),
        title: Text(
          store.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          store.address,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
        trailing: Obx(() {
          final distance = storeController.getDistanceToStore(
            store.latitude,
            store.longitude,
          );
      
          return Text(
            distance == 0.0
                ? "Calculating distance..."
                : "${distance.toStringAsFixed(2)} km away",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          );
        }),
      ),
    );
  }
}