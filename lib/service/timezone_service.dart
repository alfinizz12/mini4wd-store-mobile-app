import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimezoneService {
  static const String _timezoneKey = 'user_timezone';

  Future<void> initialize() async {
    tz.initializeTimeZones();
  }

  List<String> getAllTimezones() {
    return ['WIB', 'WITA', 'WIT', 'London'];
  }

  tz.Location getLocation(String timezone) {
    switch (timezone) {
      case 'WITA':
        return tz.getLocation('Asia/Makassar');
      case 'WIT':
        return tz.getLocation('Asia/Jayapura');
      case 'London':
        return tz.getLocation('Europe/London');
      case 'WIB':
      default:
        return tz.getLocation('Asia/Jakarta');
    }
  }

  Future<void> saveUserTimezone(String timezone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_timezoneKey, timezone);
  }

  Future<String> loadUserTimezone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_timezoneKey) ?? 'WIB';
  }
}
