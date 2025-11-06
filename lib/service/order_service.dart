import 'package:get/get.dart';
import 'package:mini4wd_store/controller/product_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  final supabase = Supabase.instance.client;
  final ProductController productController = Get.find();

  Future<String?> makeOrder(
    String userId,
    int productId,
    String address,
    int quantity,
    double total,
  ) async {
    final response = await supabase.from("orders").insert({
      "userId": userId,
      "productId": productId,
      "address": address,
      "quantity": quantity,
      "status": "pending",
      "total": total,
    }).select();

    final product = await supabase
        .from("products")
        .select()
        .eq("id", productId)
        .single();
    await supabase
        .from("products")
        .update({"stock": product['stock'] - quantity})
        .eq("id", productId);

    productController.getProducts();

    if (response.isNotEmpty) {
      return response[0]['id'].toString(); // kirim ID pesanan
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    final response = await supabase
        .from("orders")
        .select(
          "*, products(name)",
        ) // jika ada relasi ke tabel produk
        .eq("userId", userId)
        .order("created_at", ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> getDetailOrder(String orderId) async {
    final response = await supabase
        .from("orders")
        .select("*, products(name)")
        .eq("id", orderId)
        .maybeSingle();

    return response ?? {};
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await supabase.from("orders").update({"status": status}).eq("id", orderId);
  }
}
