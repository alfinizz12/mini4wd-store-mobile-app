import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final _supabase = Supabase.instance.client;

  Future<void> addAddress(String address, String userId) async {
    await _supabase.from("address").insert({
      "name": address,
      "userId": userId
    }).eq("id", userId);
  }

  Future<List<Map<String, dynamic>>> getAddress(String userId) async {
    final response = await _supabase
        .from("address")
        .select()
        .eq("userId", userId);

    return List<Map<String, dynamic>>.from(response);
  }
  

}