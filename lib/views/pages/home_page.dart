import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/controller/product_controller.dart';
import 'package:mini4wd_store/ui/components/product_card.dart';
import 'package:mini4wd_store/ui/style/colors.dart';
import 'package:mini4wd_store/views/detail_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductController _productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Mini Dash",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        "Tiny Cars. Massive Fun.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Image.asset('assets/images/tamiya.png', scale: 1.3),
          ],
        ),
        const SizedBox(height: 20),
        SearchBar(
          hintText: "Search",
          trailing: const [Icon(Icons.search)],
          onChanged: (value) {
            _productController.updateSearch(value);
          },
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _productController.categories.asMap().entries.map(
                  (entry) {
                    int index = entry.key;
                    String category = entry.value;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(category),
                        selected:
                            _productController.selectedCategoryIndex == index,
                        onSelected: (_) =>
                            _productController.selectCategory(index),
                        selectedColor: Colors.blue,
                        backgroundColor: Colors.grey[300],
                        labelStyle: TextStyle(
                          color:
                              _productController.selectedCategoryIndex == index
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Obx(() {
            if (_productController.products.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return _productController.filteredProducts.isEmpty
                ? const Center(child: Text("No Product"))
                : GridView.builder(
                    itemCount: _productController.filteredProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                    ),
                    itemBuilder: (context, index) {
                      final product =
                          _productController.filteredProducts[index];

                      return ProductCard(
                        product: product,
                        onTap: () => Get.to(
                          () => DetailProduct(product: product),
                        ),
                      );
                    },
                  );
          }),
        ),
      ],
    );
  }
}
