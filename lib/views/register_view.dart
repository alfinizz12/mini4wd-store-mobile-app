import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/controller/auth_controller.dart';
import 'package:mini4wd_store/ui/style/colors.dart';
import 'package:mini4wd_store/views/login_view.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final _formKey = GlobalKey<FormState>();
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
        title: const Text("Mini Dash"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Registration",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // USERNAME
                    TextFormField(
                      controller: _usernameController,
                      maxLength: 16,
                      decoration: const InputDecoration(hintText: "Username"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Username cannot be empty";
                        }
                        if (value.length < 3) {
                          return "Username must be at least 3 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // EMAIL
                    TextFormField(
                      controller: _emailController,
                      maxLength: 60,
                      decoration: const InputDecoration(hintText: "Email"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Email cannot be empty";
                        }
                        if (!value.contains("@")) {
                          return "Invalid email format";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // PHONE
                    TextFormField(
                      controller: _phoneController,
                      maxLength: 16,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(hintText: "Phone"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Phone number cannot be empty";
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return "Phone number must contain digits only";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // PASSWORD
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      minLines: 1,
                      maxLength: 16,
                      decoration: const InputDecoration(hintText: "Password"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password cannot be empty";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // BUTTON REGISTER
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;

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
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text("Register"),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // LINK LOGIN
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Have an account?",
                              style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 4),
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
      ),
    );
  }
}
