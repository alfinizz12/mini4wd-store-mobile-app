import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final _supabase = Supabase.instance.client;

  Future<void> addAddress(String address, String userId) async {
    await _supabase.from("address").insert({"name": address, "userId": userId});
  }

  Future<List<Map<String, dynamic>>> getAddress(String userId) async {
    final response = await _supabase
        .from("address")
        .select("id, name, userId")
        .eq("userId", userId)
        .order('id', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> deleteAddress(dynamic id) async {
    await _supabase.from("address").delete().eq("id", id);
  }
}
