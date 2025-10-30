import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/service/auth_service.dart';
import 'package:mini4wd_store/service/session_service.dart';
import 'package:mini4wd_store/views/home_view.dart';
import 'package:mini4wd_store/views/login_view.dart';
import '../model/user.dart';

class AuthController extends GetxController {
  final _authService = AuthService();
  final _sessionService = SessionService();
  User? _authUser;
  User get user => _authUser!;

  @override
  void onInit() async {
    await _getUser();
    super.onInit();
  }

  Future<void> login(String email, String password) async {
    final response = await _authService.login(email, password);

    if (response != null) {
      Get.snackbar(
        "Failed",
        response,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.snackbar(
      "Success",
      "Logged In Successfully!",
      colorText: Colors.white,
      backgroundColor: Colors.green,
    );

    Get.off(() => HomeView());
  }

  Future<void> register(
    String email,
    String username,
    String password,
    String phone,
  ) async {
    final response = await _authService.register(
      email,
      username,
      password,
      phone,
    );

    if (response != null) {
      Get.snackbar(
        "Failed",
        response,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.snackbar(
      "Success",
      "Register Success!",
      colorText: Colors.white,
      backgroundColor: Colors.green,
    );

    Get.to(() => LoginView());
  }

  Future<void> logout() async {
    final session = await _sessionService.loadSession();

    if (session == null) {
      Get.snackbar(
        "Logout",
        "Logout Failed",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
    await _authService.logout();
    Get.offAll(() => LoginView());
    Get.snackbar(
      "Logout",
      "Logout Success",
      colorText: Colors.white,
      backgroundColor: Colors.green,
    );
  }

  Future<void> _getUser() async {
    final authenticatedUser = await _sessionService.loadSession();
    if (authenticatedUser == null) {
      _authUser = null;
      return;
    }

    _authUser = User.fromMap(authenticatedUser);
  }
}
