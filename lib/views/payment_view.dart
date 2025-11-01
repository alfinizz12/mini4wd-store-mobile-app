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

    // Load order detail saat halaman dibuka
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
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
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
                        isPending
                            ? "Menunggu Pembayaran..."
                            : "Pembayaran Berhasil!",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      ListTile(
                        title: const Text("Order ID"),
                        subtitle: Text(order['id'].toString()),
                      ),
                      ListTile(
                        title: const Text("Alamat"),
                        subtitle: Text(order['address']),
                      ),
                      ListTile(
                        title: const Text("Jumlah"),
                        subtitle: Text("${order['quantity']} pcs"),
                      ),
                      ListTile(
                        title: const Text("Total"),
                        subtitle: Obx(() {
                          return FutureBuilder<double>(
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
                                style: const TextStyle(fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          );
                        }),
                      ),
                      ListTile(
                        title: const Text("Tanggal"),
                        subtitle: Text(createdAtFormatted),
                      ),
                      const SizedBox(height: 20),
                      if (isPending)
                        ElevatedButton.icon(
                          onPressed: () {
                            _showPaymentDialog(context, orderController, order);
                          },
                          icon: const Icon(Icons.payment),
                          label: const Text("Bayar Sekarang"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                          ),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.home),
                          label: const Text("Kembali ke Home"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
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

    Get.defaultDialog(
      title: "Simulasi Pembayaran",
      content: Column(
        children: [
          TextField(
            controller: cardNumberController,
            decoration: const InputDecoration(
              labelText: "Nomor Kartu",
              hintText: "1234 5678 9012 3456",
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Nama Pemilik Kartu",
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (cardNumberController.text.isEmpty ||
                  nameController.text.isEmpty) {
                Get.snackbar("Error", "Mohon isi semua field.");
                return;
              }

              Get.back();
              Get.dialog(
                  const Center(child: CircularProgressIndicator()),
                  barrierDismissible: false);

              await Future.delayed(const Duration(seconds: 2));
              await orderController.updateOrderStatus(order['id'], "paid");

              Get.back();
              Get.snackbar(
                "Berhasil",
                "Pembayaran selesai untuk Order #${order['id']}",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text("Bayar Sekarang"),
          ),
        ],
      ),
    );
  }
}
