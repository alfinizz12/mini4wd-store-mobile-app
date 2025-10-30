import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/controller/auth_controller.dart';
import 'package:mini4wd_store/ui/components/profile_menu.dart';
import 'package:mini4wd_store/views/preferences_view.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final RxBool _isLoading = false.obs;

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("My Profile", style: Theme.of(context).textTheme.headlineMedium,),
          SizedBox(height: 20,),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.amberAccent,
                  radius: MediaQuery.of(context).size.height * 0.04,
                  child: Text(
                    authController.user.username
                        .toString()
                        .substring(0, 1)
                        .toUpperCase(),
                    style: TextStyle(
                      fontSize: 32
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authController.user.username,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 10),
                    Text(authController.user.email),
                  ],
                ),
              ],
            ),
          ),
          ProfileMenu(title: "Preferences", icon: Icons.settings, onTap: () {
            Get.to(() => PreferencesView());
          }),
          ProfileMenu(
            title: "Order History",
            icon: Icons.history_outlined,
            onTap: () {},
          ),
          ProfileMenu(
            title: "Log Out",
            icon: Icons.logout,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Logout Confirmation"),
                    content: Obx(
                      () => _isLoading.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Are you sure you want to log out?"),
                    ),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _isLoading.value = true;
                          await authController.logout();
                          _isLoading.value = false;
                        },
                        child: Text("Yes"),
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
