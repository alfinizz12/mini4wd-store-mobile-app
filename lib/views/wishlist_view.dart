import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/controller/currency_controller.dart';
import 'package:mini4wd_store/controller/wishlist_controller.dart';
import 'package:mini4wd_store/model/wishlist_product.dart';
import 'package:mini4wd_store/ui/style/colors.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final WishlistController wishlistController =
        Get.find<WishlistController>();
    final currencyController = Get.find<CurrencyController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Wishlist"),
        backgroundColor: AppColors.primaryRed,
        centerTitle: true,
      ),
      body: Obx(() {
        if (wishlistController.favorites.isEmpty) {
          return const Center(
            child: Text(
              "Wishlist product is empty 😢",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: wishlistController.favorites.length,
          itemBuilder: (context, index) {
            final WishlistProduct product = wishlistController.favorites[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Obx(() {
                  return FutureBuilder<double>(
                    future: currencyController.convert(product.price),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text("...");
                      }
                      final convertedPrice = snapshot.data!;
                      return Text(
                        currencyController.formatCurrency(convertedPrice),
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  );
                }),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    wishlistController.toggleFavorite(product);
                    Get.snackbar(
                      "Wishlist",
                      "${product.name} removed from wishlist",
                      snackPosition: SnackPosition.TOP,
                      colorText: Colors.white,
                      backgroundColor: Colors.redAccent,
                    );
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
