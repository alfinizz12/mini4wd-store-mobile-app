import 'package:live_currency_rate/live_currency_rate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyService {
  static const String _currencyKey = 'user_currency';

  Future<String> getUserCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currencyKey) ?? 'IDR';
  }

  Future<void> saveUserCurrency(String currencyCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currencyCode);
  }

  Future<CurrencyRate> convertCurrency(String from, String to, double amount) async {
    return LiveCurrencyRate.convertCurrency(from, to, amount);
  }
}
