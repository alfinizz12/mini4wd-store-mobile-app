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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Addresses")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Obx(() {
          if (_authController.address.isEmpty) {
            return Center(child: Text("No address added"));
          }

          return ListView.separated(
            itemCount: _authController.address.length,
            itemBuilder: (context, index) => ListTile(
              leading: Icon(Icons.location_on_outlined),
              title: Text(_authController.address[index]),
            ),
            separatorBuilder: (context, index) => SizedBox(height: 5),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  children: [
                    Text(
                      "Add address",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(hint: Text("Your address")),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_addressController.text.isEmpty) {
                          return;
                        }

                        await _userService.addAddress(
                          _addressController.text,
                          _authController.user!.id,
                        );
                        Get.back();
                      },
                      child: Text("Add address"),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
