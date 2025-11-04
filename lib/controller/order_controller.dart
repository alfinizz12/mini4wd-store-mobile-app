import 'package:get/get.dart';
import 'package:mini4wd_store/service/order_service.dart';
import 'package:mini4wd_store/controller/auth_controller.dart';

class OrderController extends GetxController {
  final _orderService = OrderService();

  // List order history
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  final RxMap<String, dynamic> orderDetail = <String, dynamic>{}.obs;

  Future<String?> makeUserOrder(
    String userId,
    int productId,
    String address,
    int quantity,
    double total,
  ) async {
    return await _orderService.makeOrder(
      userId,
      productId,
      address,
      quantity,
      total,
    );
  }

  Future<void> getOrderHistory() async {
    isLoading.value = true;
    final auth = Get.find<AuthController>();
    final userId = auth.user?.id;
    if (userId == null) return;

    final response = await _orderService.supabase
        .from("orders")
        .select()
        .eq("userId", userId)
        .order("created_at", ascending: false);

    orders.assignAll(response);
    isLoading.value = false;
  }

  Future<Map<String, dynamic>?> getUserDetailOrder(String orderId) async {
    final response = await _orderService.getDetailOrder(orderId);

    if (response.isNotEmpty) {
      orderDetail.value = response; 
    }

    return response;
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _orderService.updateOrderStatus(orderId, status);

    if (orderDetail.isNotEmpty && orderDetail['id'].toString() == orderId) {
      orderDetail['status'] = status;
    }
  }
}
