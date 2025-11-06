import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/controller/order_controller.dart';
import 'package:mini4wd_store/controller/currency_controller.dart';
import 'package:mini4wd_store/controller/timezone_controller.dart';
import 'package:mini4wd_store/views/payment_view.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.put(OrderController());
    final currencyController = Get.find<CurrencyController>();
    final timezoneController = Get.find<TimezoneController>();

    orderController.getOrderHistory();

    return Scaffold(
      appBar: AppBar(title: const Text('Order History'), centerTitle: true),
      body: Obx(() {
        if (orderController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (orderController.orders.isEmpty) {
          return const Center(
            child: Text(
              "No order/transactions",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: orderController.orders.length,
          itemBuilder: (context, index) {
            final order = orderController.orders[index];

            final formattedDate =
                timezoneController.convertToUserTimezone(order['created_at'] ?? '');

            // Ambil nama produk (kalau ada)
            final productName = order['product']?['name'] ?? 'Unknown Product';

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                title: Text(
                  "Order #${order['id']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    // 🟢 Tambahan: tampilkan nama produk
                    Text(
                      "Product: $productName",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text("Address: ${order['address']}"),
                    Text("Quantity: ${order['quantity']} pcs"),
                    FutureBuilder<double>(
                      future: currencyController
                          .convert(order['total'].toDouble()),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Text("Total: ...");
                        }
                        final converted = snapshot.data!;
                        return Text(
                          "Total: ${currencyController.formatCurrency(converted)}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        );
                      },
                    ),
                    Text(
                      "Status: ${order['status']}",
                      style: TextStyle(
                        color: order['status'] == 'pending'
                            ? Colors.orange
                            : Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Order date: $formattedDate",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                onTap: () {
                  Get.to(() => PaymentView(orderId: order['id'].toString()));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
