import 'package:currency_formatter/currency_formatter.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/service/currency_service.dart';

class CurrencyController extends GetxController {
  final CurrencyService _currencyService = CurrencyService();

  var currentCurrency = 'IDR'.obs;
  var fromCurrency = 'IDR'.obs;
  var toCurrency = 'USD'.obs;

  final Map<String, String> symbols = {
    'IDR': 'Rp',
    'USD': '\$',
    'JPY': '¥',
    'KRW': '₩',
    'EUR': '€',
  };

  final List<String> availableCurrencies = [
    'IDR', 'USD', 'JPY', 'KRW', 'EUR'
  ];

  @override
  void onInit() {
    super.onInit();
    _loadUserCurrency();
  }

  Future<void> _loadUserCurrency() async {
    final savedCurrency = await _currencyService.getUserCurrency();
    if (savedCurrency.isNotEmpty) {
      toCurrency.value = savedCurrency;
    }
  }

  Future<void> setCurrency({String? from, String? to}) async {
    if (from != null) fromCurrency.value = from;
    if (to != null) {
      toCurrency.value = to;
      currentCurrency.value = to;
      await _currencyService.saveUserCurrency(to);
    }
  }

  Future<double> convert(double amount) async {
    final rate = await _currencyService.convertCurrency(
      fromCurrency.value,
      toCurrency.value,
      amount,
    );
    return rate.result;
  }

  String formatCurrency(double value) {
  final symbol = symbols[toCurrency.value] ?? toCurrency.value;

  final settings = CurrencyFormat(
    symbol: symbol,
    symbolSide: SymbolSide.left,
    thousandSeparator: '.',
    decimalSeparator: ',',
    symbolSeparator: ' ',
  );

  return CurrencyFormatter.format(value, settings);
}
}
