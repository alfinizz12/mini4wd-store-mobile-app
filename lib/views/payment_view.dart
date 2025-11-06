import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/controller/order_controller.dart';
import 'package:mini4wd_store/controller/currency_controller.dart';
import 'package:mini4wd_store/controller/timezone_controller.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key, this.orderId});
  final String? orderId;

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();
    final currencyController = Get.find<CurrencyController>();
    final timezoneController = Get.find<TimezoneController>();

    if (orderId != null) {
      orderController.getUserDetailOrder(orderId!);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Payment Status")),
      body: Obx(() {
        final order = orderController.orderDetail;
        if (order.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final isPending = order['status'] == 'pending';
        final createdAtFormatted = order['created_at'] != null
            ? timezoneController.convertToUserTimezone(order['created_at'])
            : '-';

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Card(
              elevation: 6,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPending ? Icons.pending_actions : Icons.check_circle,
                        color: isPending ? Colors.orange : Colors.green,
                        size: 90,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isPending ? "Waiting for payment..." : "Payment Successful!",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(thickness: 1.2),

                      // --- Product Name Section ---
                      ListTile(
                        title: const Text("Product"),
                        subtitle: Text(
                          order['products']?['name'] ?? 'Unknown Product',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const Divider(thickness: 1.2),

                      // --- Order Info Section ---
                      ListTile(
                        title: const Text("Order ID"),
                        subtitle: Text(order['id'].toString()),
                      ),
                      ListTile(
                        title: const Text("Shipping Address"),
                        subtitle: Text(order['address']),
                      ),
                      ListTile(
                        title: const Text("Quantity"),
                        subtitle: Text("${order['quantity']} pcs"),
                      ),
                      ListTile(
                        title: const Text("Total Payment"),
                        subtitle: FutureBuilder<double>(
                          future: currencyController.convert(
                              double.parse(order['total'].toString())),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Text("...");
                            }
                            final convertedPrice = snapshot.data!;
                            return Text(
                              currencyController
                                  .formatCurrency(convertedPrice)
                                  .toString(),
                              style: const TextStyle(fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text("Order Date"),
                        subtitle: Text(createdAtFormatted),
                      ),
                      const SizedBox(height: 20),

                      if (isPending)
                        ElevatedButton.icon(
                          onPressed: () {
                            _showPaymentDialog(context, orderController, order);
                          },
                          icon: const Icon(Icons.payment),
                          label: const Text("Proceed to Payment"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.home),
                          label: const Text("Back to Home"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showPaymentDialog(
    BuildContext context,
    OrderController orderController,
    Map<String, dynamic> order,
  ) {
    final TextEditingController cardNumberController = TextEditingController();
    final TextEditingController nameController = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: const Icon(
                        Icons.credit_card,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Payment",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Please enter your payment details",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Form fields
                TextField(
                  controller: cardNumberController,
                  decoration: InputDecoration(
                    labelText: "Card Number",
                    prefixIcon: const Icon(Icons.credit_card_rounded),
                    hintText: "1234 5678 9012 3456",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Card Holder Name",
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (cardNumberController.text.isEmpty ||
                              nameController.text.isEmpty) {
                            Get.snackbar("Error", "Please fill in all fields.");
                            return;
                          }

                          Get.back(); // Close dialog
                          Get.dialog(
                            const Center(child: CircularProgressIndicator()),
                            barrierDismissible: false,
                          );

                          await Future.delayed(const Duration(seconds: 2));
                          await orderController.updateOrderStatus(
                            order['id'],
                            "paid",
                          );
                          await orderController.getOrderHistory();

                          Get.back();
                          Get.snackbar(
                            "Success",
                            "Payment successful for Order ID: #${order['id']}",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        },
                        icon: const Icon(Icons.payment),
                        label: const Text("Pay Now"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
