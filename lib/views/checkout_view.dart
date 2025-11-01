import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/controller/auth_controller.dart';
import 'package:mini4wd_store/controller/order_controller.dart';
import 'package:mini4wd_store/controller/currency_controller.dart';
import 'package:mini4wd_store/model/product.dart';
import 'package:mini4wd_store/service/notification_service.dart';
import 'package:mini4wd_store/views/payment_view.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({
    super.key,
    required this.product,
    required this.quantity,
    required this.total,
  });

  final Product product;
  final int quantity;
  final double total;

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final AuthController authController = Get.find<AuthController>();
  final OrderController orderController = Get.put(OrderController());
  final CurrencyController currencyController = Get.find<CurrencyController>();
  final RxString selectedAddress = ''.obs;

  @override
  void initState() {
    super.initState();
    authController.getUserAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Image.network(
                  widget.product.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                title: Text(widget.product.name),
                subtitle: Obx(() {
                  return FutureBuilder<double>(
                    future: currencyController.convert(
                      widget.product.price.toDouble(),
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text("...");
                      }
                      final convertedPrice = snapshot.data!;
                      return Text(
                        "Harga: ${currencyController.formatCurrency(convertedPrice)}",
                      );
                    },
                  );
                }),
                trailing: Text("Qty : ${widget.quantity}"),
              ),

              const Divider(height: 30),

              Text(
                "Pilih Alamat Pengiriman",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              Obx(() {
                final addresses = authController.address;

                if (addresses.isEmpty) {
                  return const Text("Belum ada alamat tersimpan.");
                }

                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  hint: const Text("Pilih alamat pengiriman"),
                  initialValue: selectedAddress.value.isEmpty
                      ? null
                      : selectedAddress.value,
                  items: addresses
                      .map(
                        (addr) => DropdownMenuItem<String>(
                          value: addr,
                          child: Text(addr),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) selectedAddress.value = value;
                  },
                );
              }),

              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Obx(() {
                    return FutureBuilder<double>(
                      future: currencyController.convert(widget.total),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Text("...");
                        }
                        final converted = snapshot.data!;
                        return Text(
                          currencyController.formatCurrency(converted),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (selectedAddress.value.isEmpty) {
                Get.snackbar(
                  "Alamat belum dipilih",
                  "Silakan pilih alamat pengiriman terlebih dahulu",
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
                return;
              }

              final orderId = await orderController.makeUserOrder(
                authController.user!.id,
                widget.product.id,
                selectedAddress.value,
                widget.quantity,
                widget.total,
              );

              if (orderId == null) {
                Get.snackbar(
                  "Gagal",
                  "Terjadi kesalahan saat membuat order",
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }

              NotificationService().showNotification(title: "Order Success", body: "Order ID : $orderId");

              Get.off(() => PaymentView(orderId: orderId));
            },
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
            child: const Text("Create Order"),
          ),
        ),
      ),
    );
  }
}
