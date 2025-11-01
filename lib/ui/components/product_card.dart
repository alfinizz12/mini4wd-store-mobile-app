import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/controller/auth_controller.dart';
import 'package:mini4wd_store/controller/currency_controller.dart';
import 'package:mini4wd_store/controller/wishlist_controller.dart';
import 'package:mini4wd_store/model/product.dart';
import 'package:mini4wd_store/model/wishlist_product.dart';
import 'package:mini4wd_store/ui/style/colors.dart';

class ProductCard extends StatelessWidget {
  ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final Function() onTap;

  final currencyController = Get.find<CurrencyController>();
  final WishlistController favoriteController = Get.find<WishlistController>();
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryRed,
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center, 
                      children: [
                        Obx(() {
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
                        const SizedBox(width: 8),
                        Obx(() => IconButton(
                          onPressed: (){
                            favoriteController.toggleFavorite(
                              WishlistProduct(
                                id: product.id,
                                name: product.name,
                                price: product.price,
                                image: product.image,
                                userId: _authController.user!.id,
                              ),
                            );
                          }, 
                          icon: Icon(
                            Icons.favorite,
                            color: favoriteController.isFavorite(product.id) ? Colors.red : Colors.black,
                          )
                        ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


