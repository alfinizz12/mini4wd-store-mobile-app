import 'package:get/get.dart';
import 'package:mini4wd_store/service/timezone_service.dart';
import 'package:timezone/timezone.dart' as tz;

class TimezoneController extends GetxController {
  final TimezoneService _timezoneService = TimezoneService();

  var currentTimezone = ''.obs;
  var availableTimezones = <String>[].obs;
  var currentTime = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initTimezone();
  }

  Future<void> _initTimezone() async {
    await _timezoneService.initialize();
    availableTimezones.value = _timezoneService.getAllTimezones();
    currentTimezone.value = await _timezoneService.loadUserTimezone();
    _updateCurrentTime();
  }

  Future<void> setTimezone(String timezone) async {
    currentTimezone.value = timezone;
    await _timezoneService.saveUserTimezone(timezone);
    _updateCurrentTime();
  }

  void _updateCurrentTime() {
    final location = _timezoneService.getLocation(currentTimezone.value);
    final now = tz.TZDateTime.now(location);
    currentTime.value =
        "${now.day}-${now.month}-${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  String convertToUserTimezone(String utcString) {
    try {
      final utcTime = DateTime.parse(utcString).toUtc();
      final location = _timezoneService.getLocation(currentTimezone.value);
      final localTime = tz.TZDateTime.from(utcTime, location);
      return "${localTime.day}-${localTime.month}-${localTime.year} ${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return utcString;
    }
  }
}
