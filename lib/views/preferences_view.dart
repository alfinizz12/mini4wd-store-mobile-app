import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/controller/currency_controller.dart';
import 'package:mini4wd_store/controller/timezone_controller.dart';

class PreferencesView extends StatelessWidget {
  PreferencesView({super.key});

  final timezoneController = Get.find<TimezoneController>();
  final currencyController = Get.find<CurrencyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preferences"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return ListView(
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.timer),
                  title: const Text("Change Timezone"),
                  subtitle: Text(
                    "Current: ${timezoneController.currentTime.value}",
                  ),
                  trailing: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: timezoneController.currentTimezone.value,
                      items: timezoneController.availableTimezones
                          .map((zone) => DropdownMenuItem(
                                value: zone,
                                child: Text(zone, textAlign: TextAlign.end,),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          timezoneController.setTimezone(value);
                        }
                      },
                    ),
                  ),
                ),
              ),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.currency_exchange),
                  title: const Text("Change Currency"),
                  subtitle: Text(
                    "Current: ${currencyController.currentCurrency.value}",
                  ),
                  trailing: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: currencyController.currentCurrency.value,
                      items: currencyController.availableCurrencies
                          .map((zone) => DropdownMenuItem(
                                value: zone,
                                child: Text(zone),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          currencyController.setCurrency(from: currencyController.fromCurrency.value ,to: value);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
