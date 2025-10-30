import 'dart:convert';
import 'package:mini4wd_store/model/product.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  final Uri _url = Uri.parse("https://mini4wd-api.vercel.app/api/product");
  final _supabase = Supabase.instance.client;

  Future<List<Product>> getAllProducts() async {
    final response = await http.get(_url);
    final result = jsonDecode(response.body);
    final List products = result['data'];

    return products.map((product) => Product.fromJson(product)).toList();
  }

  Future addToFavorite(Product product, String userId) async {
    await _supabase.from('favorites').insert({
      'userId': userId,
      'productId': product.id,
    });
  }
}
