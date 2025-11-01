import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  final supabase = Supabase.instance.client;

  Future<String?> makeOrder(String userId, int productId, String address, int quantity, double total) async {
  final response = await supabase.from("orders").insert({
    "userId": userId,
    "productId": productId, 
    "address": address,
    "quantity": quantity,
    "status": "pending",
    "total": total
  }).select();

  if (response.isNotEmpty) {
    return response[0]['id'].toString(); // kirim ID pesanan
  }
  return null;
}


  Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
  final response = await supabase
      .from("orders")
      .select("*, products(name, image, price)") // jika ada relasi ke tabel produk
      .eq("userId", userId)
      .order("created_at", ascending: false);

  return List<Map<String, dynamic>>.from(response);
}

  Future<Map<String, dynamic>> getDetailOrder(String orderId) async {
    final response = await supabase.from("orders").select().eq("id", orderId);

    return response[0];
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
  await supabase.from("orders").update({
    "status": status,
  }).eq("id", orderId);
}


}