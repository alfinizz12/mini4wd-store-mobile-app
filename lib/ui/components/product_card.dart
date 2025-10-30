import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/controller/currency_controller.dart';
import 'package:mini4wd_store/model/product.dart';
import 'package:mini4wd_store/ui/style/colors.dart';

class ProductCard extends StatelessWidget {
  ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.addToFavorite,
  });

  final Product product;
  final Function() onTap;
  final Function() addToFavorite;

  final currencyController = Get.find<CurrencyController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
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
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() {
                          return FutureBuilder<double>(
                            future: currencyController.convert(product.price),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text("...");
                              }
                              final convertedPrice = snapshot.data!;
                              return Text(
                                currencyController.formatCurrency(convertedPrice),
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          );
                        }),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.chipSelected,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: addToFavorite,
                            icon: const Icon(
                              Icons.favorite,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
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
