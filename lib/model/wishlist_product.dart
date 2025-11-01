import 'package:hive/hive.dart';

part 'wishlist_product.g.dart';

@HiveType(typeId: 1)
class WishlistProduct {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double price;

  @HiveField(3)
  String image;

  @HiveField(4)
  String userId;

  WishlistProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.userId
  });
}
