import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/controller/auth_controller.dart';
import 'package:mini4wd_store/ui/components/profile_menu.dart';
import 'package:mini4wd_store/views/address_view.dart';
import 'package:mini4wd_store/views/order_history_view.dart';
import 'package:mini4wd_store/views/preferences_view.dart';
import 'package:mini4wd_store/views/wishlist_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final RxBool _isLoading = false.obs;
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("My Profile", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          Obx(() {
            final user = authController.user;
            if (user == null) {
              return const Text("Not logged in");
            }

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.height * 0.05,
                    backgroundColor: Colors.amberAccent,
                    backgroundImage: AssetImage('assets/images/alfin.jpeg'),
                  ),

                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),
                      Text(user.email),
                    ],
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          ProfileMenu(
            title: "Address",
            icon: Icons.format_list_numbered,
            onTap: () => Get.to(() => AddressView()),
          ),
          ProfileMenu(
            title: "Preferences",
            icon: Icons.settings,
            onTap: () => Get.to(() => PreferencesView()),
          ),
          ProfileMenu(
            title: "My Wishlist",
            icon: Icons.favorite_border,
            onTap: () => Get.to(() => WishlistView()),
          ),
          ProfileMenu(
            title: "Order History",
            icon: Icons.history_outlined,
            onTap: () => Get.to(() => OrderHistoryView()),
          ),
          ProfileMenu(
            title: "Log Out",
            icon: Icons.logout,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Logout Confirmation"),
                    content: Obx(
                      () => _isLoading.value
                          ? const CircularProgressIndicator()
                          : const Text("Are you sure you want to log out?"),
                    ),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await authController.logout();
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
