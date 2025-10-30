
import 'package:get/get.dart';
import 'package:mini4wd_store/model/product.dart';
import 'package:mini4wd_store/service/api/product_api_service.dart';

class ProductController extends GetxController {
  final ProductService _productService = ProductService();
  final RxList<Product> _products = <Product>[].obs;
  final RxList<Product> _filteredProducts = <Product>[].obs;
  final RxInt _selectedCategoryIndex = (-1).obs;
  final RxString _searchQuery = ''.obs;

  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  int get selectedCategoryIndex => _selectedCategoryIndex.value;

  final List<String> categories = [
    "Mini 4WD",
    "Batteries",
    "Wheels",
    "Tires",
    "Brakes",
    "Advanced",
    "Gears",
    "Dampers",
  ];

  @override
  void onInit() async {
    super.onInit();
    getProducts();
  }

  void getProducts() async{
    final data = await _productService.getAllProducts();
    _products.assignAll(data);
    filteredProducts.assignAll(data); 
  }

  void addToFavorite(Product product, userId) async {
    await _productService.addToFavorite(product, userId);
  }

  // logika pilih category
  void selectCategory(int index) {
    // unselect
    if (_selectedCategoryIndex.value == index) {
      _selectedCategoryIndex.value = -1;
      filteredProducts.assignAll(_products);
      return;
    }

    // select category
    _selectedCategoryIndex.value = index;
    final selectedCategory = categories[index].toLowerCase();

    filteredProducts.assignAll(
      _products.where((p) {
        return p.category.any((c) =>
            c.toString().toLowerCase() == selectedCategory);
      }).toList(),
    );
  }

  // logika search
  void updateSearch(String query) {
    _searchQuery.value = query;
    applyFilters();
  }

  // penggabungan filter dan search
  void applyFilters() {
    List<Product> filtered = _products;

    final categoryIndex = _selectedCategoryIndex.value;
    final query = _searchQuery.value.toLowerCase();

    // Filter kategori
    if (categoryIndex != -1) {
      final selectedCategory = categories[categoryIndex].toLowerCase();
      filtered = filtered.where((p) {
        return p.category.any(
            (c) => c.toString().toLowerCase() == selectedCategory);
      }).toList();
    }

    // Filter pencarian
    if (query.isNotEmpty) {
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query);
      }).toList();
    }

    filteredProducts.assignAll(filtered);
  }
}