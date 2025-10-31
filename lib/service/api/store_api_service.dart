import 'dart:convert';
import 'package:mini4wd_store/model/store.dart';
import 'package:http/http.dart' as http;

class StoreApiService {
  final Uri _url = Uri.parse("https://mini4wd-api.vercel.app/api/store");

  Future<List<Store>> getAllStore() async {
    final response = await http.get(_url);
    final result = jsonDecode(response.body);

    final List stores = result['data'] ?? [];

    return stores.map((store) => Store.fromJson(store)).toList();
  }
}