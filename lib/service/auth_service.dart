import 'package:bcrypt/bcrypt.dart';
import 'package:mini4wd_store/service/session_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;
  final _sessionService = SessionService();

  Future<String?> register(
    String email,
    String username,
    String password,
    String phone,
  ) async {
    try {
      final res = await _supabase
          .from('users')
          .select('email')
          .eq('email', email)
          .count();

      if (res.count > 0) throw Exception("Email already used!");

      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

      await _supabase.from("users").insert({
        "email": email,
        "username": username,
        "password": hashedPassword,
        "phone": phone,
      });
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final user = await _supabase.from('users').select().eq("email", email);

      if (user.isEmpty) throw Exception("User not found!");

      if (!(BCrypt.checkpw(password, user[0]['password'].toString()))) {
        throw Exception("Wrong Password");
      }

      // create session token
      await _sessionService.saveSession(user[0]['id'], email, user[0]['username']);
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  Future<void> logout() async {
    await _sessionService.clearSession();
  }
}
