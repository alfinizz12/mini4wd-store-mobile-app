import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart';

class SessionService {
  final _storage = const FlutterSecureStorage();

  Future<Key> _getOrCreateKey() async {
    String? savedKey = await _storage.read(key: "session_key");

    if (savedKey != null) {
      return Key.fromBase64(savedKey);
    }

    final newKey = Key.fromSecureRandom(32);
    await _storage.write(key: "session_key", value: newKey.base64);
    return newKey;
  }

  Future<void> saveSession(String id, String email, String username) async {
    final key = await _getOrCreateKey();
    final iv = IV.fromSecureRandom(8);
    final encrypter = Encrypter(Salsa20(key));

    final sessionData = jsonEncode({
      "id": id,
      "email": email,
      "username": username,
      "created_at": DateTime.now().toIso8601String()
    });

    final encrypted = encrypter.encrypt(sessionData, iv: iv);

    await _storage.write(key: "session", value: encrypted.base64);
    await _storage.write(key: "session_iv", value: iv.base64);
  }

  Future<Map<String, dynamic>?> loadSession() async {
    final encrypted = await _storage.read(key: "session");
    final ivBase64 = await _storage.read(key: "session_iv");
    final keyBase64 = await _storage.read(key: "session_key");

    if (encrypted == null || ivBase64 == null || keyBase64 == null) return null;

    final key = Key.fromBase64(keyBase64);
    final iv = IV.fromBase64(ivBase64);
    final encrypter = Encrypter(Salsa20(key));

    final decrypted = encrypter.decrypt64(encrypted, iv: iv);
    return jsonDecode(decrypted);
  }

  Future<void> clearSession() async {
    await _storage.delete(key: "session");
    await _storage.delete(key: "session_iv");
    await _storage.delete(key: "session_key");
  }
}
