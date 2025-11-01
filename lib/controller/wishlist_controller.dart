import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mini4wd_store/model/wishlist_product.dart';
import 'package:mini4wd_store/controller/auth_controller.dart';

class WishlistController extends GetxController {
  static const String _boxName = 'favoritesBox';
  late Box<WishlistProduct> _favoritesBox;

  final favorites = <WishlistProduct>[].obs;
  final _authController = Get.find<AuthController>();

  @override
  void onInit() async {
    super.onInit();
    await _openBox();
    _loadFavorites();
  }

  Future<void> _openBox() async {
    _favoritesBox = await Hive.openBox<WishlistProduct>(_boxName);
  }

  void _loadFavorites() {
    final userId = _authController.user?.id;
    if (userId == null) {
      favorites.clear();
      return;
    }

    final allFavorites = _favoritesBox.values.toList();
    favorites.assignAll(
      allFavorites.where((fav) => fav.userId == userId).toList(),
    );
  }

  void reloadForCurrentUser() {
    _loadFavorites();
  }

  bool isFavorite(int productId) {
    final userId = _authController.user?.id;
    if (userId == null) return false;

    return favorites.any((fav) => fav.id == productId && fav.userId == userId);
  }

  void toggleFavorite(WishlistProduct product) {
    final userId = _authController.user?.id;
    if (userId == null) {
      Get.snackbar(
        "Login Required",
        "Silakan login untuk menambahkan ke wishlist",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final existingKey = _favoritesBox.keys.firstWhere(
      (key) {
        final fav = _favoritesBox.get(key);
        return fav?.id == product.id && fav?.userId == userId;
      },
      orElse: () => null,
    );

    if (existingKey != null) {
      _favoritesBox.delete(existingKey);
    } else {
      _favoritesBox.add(product);
    }

    _loadFavorites();
  }
}
