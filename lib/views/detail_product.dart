import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/controller/currency_controller.dart';
import 'package:mini4wd_store/model/product.dart';
import 'package:mini4wd_store/views/checkout_view.dart';

class DetailProduct extends StatelessWidget {
  DetailProduct({super.key, required this.product});
  final Product product;
  final CurrencyController currencyController = Get.find<CurrencyController>();

  final RxInt items = 1.obs;

  void increment() {
    if (items.value < product.stock) {
      items.value++;
    }
  }

  void decrement() {
    if (items.value != 1) {
      items.value--;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Details")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Image.network(product.image),
              SizedBox(height: 10),
              Text(
                product.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 5),
              Obx(() {
                return FutureBuilder<double>(
                  future: currencyController.convert(product.price), 
                  builder: (context, snapshot){
                    if(!snapshot.hasData){
                      return Text("Loading Price ...");
                    }

                    return Text(currencyController.formatCurrency(snapshot.data!));
                  }
                );
              }),
              Text("Stock : ${product.stock.toString()}"),
              SizedBox(height: 10),
              SingleChildScrollView(
                child: Row(
                  spacing: 10,
                  children: product.category
                      .map((c) => Chip(label: Text(c)))
                      .toList(),
                ),
              ),
              SizedBox(height: 10),
              Text(
                product.description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: IconButton(
                      onPressed: () => decrement(),
                      icon: Icon(Icons.remove),
                      color: Colors.white,
                    ),
                  ),
                  Obx(() => Text(items.value.toString())),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: IconButton(
                      onPressed: () => increment(),
                      icon: Icon(Icons.add), 
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Get.off(() => CheckoutView(
                      product: product, 
                      quantity: items.value,
                      total: product.price * items.value,
                    )
                  );
                }, 
                child: Text("Order now")
              ),
            ),
          ],
        ),
      ),
    );
  }
}
