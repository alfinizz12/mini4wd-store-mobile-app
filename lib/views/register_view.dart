import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/controller/auth_controller.dart';
import 'package:mini4wd_store/ui/style/colors.dart';
import 'package:mini4wd_store/views/login_view.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});
  final RxBool _isLoading = false.obs;
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mini Dash"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Registration",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _usernameController,
                    maxLength: 16,
                    decoration: InputDecoration(hint: Text("Username")),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    maxLength: 60,
                    decoration: InputDecoration(hint: Text("Email")),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    maxLength: 16,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(hint: Text("Phone")),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    minLines: 1,
                    maxLength: 16,
                    decoration: InputDecoration(hint: Text("Password")),
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_emailController.text.isEmpty ||
                            _usernameController.text.isEmpty ||
                            _passwordController.text.isEmpty ||
                            _phoneController.text.isEmpty) {
                          Get.snackbar(
                            "Registration Failed",
                            "Field should not be empty",
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        _isLoading.value = true;
                        await authController.register(
                          _emailController.text,
                          _usernameController.text,
                          _passwordController.text,
                          _phoneController.text,
                        );
                        _isLoading.value = false;
                      },
                      child: Obx(
                        () => _isLoading.value
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("Register"),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Have account?", style: TextStyle(fontSize: 12)),
                        SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Get.off(() => LoginView());
                          },
                          child: Text(
                            "Login!",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
