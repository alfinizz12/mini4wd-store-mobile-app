import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/controller/auth_controller.dart';
import 'package:mini4wd_store/service/user_service.dart';

class AddressView extends StatefulWidget {
  const AddressView({super.key});

  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  final TextEditingController _addressController = TextEditingController();
  final UserService _userService = UserService();
  final AuthController _authController = Get.find();

  @override
  void initState() {
    super.initState();
    _authController.getUserAddress();
  }

  Future<void> _refreshAddresses() async {
    await _authController.getUserAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Addresses")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(() {
          if (_authController.address.isEmpty) {
            return const Center(child: Text("No address added"));
          }

          return RefreshIndicator(
            onRefresh: _refreshAddresses,
            child: ListView.separated(
              itemCount: _authController.address.length,
              itemBuilder: (context, index) {
                final address = _authController.address[index];

                return ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(address['name'] ?? '-'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      await _authController.deleteAddress(address['id']);
                      Get.snackbar(
                        "Deleted",
                        "Address has been removed",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },
                  ),
                );
              },

              separatorBuilder: (context, index) => const SizedBox(height: 5),
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  children: [
                    Text(
                      "Add address",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        hintText: "Your address",
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_addressController.text.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Address cannot be empty",
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        await _userService.addAddress(
                          _addressController.text,
                          _authController.user!.id,
                        );
                        _addressController.clear();
                        Get.back();
                        await _refreshAddresses();
                      },
                      child: const Text("Add address"),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
