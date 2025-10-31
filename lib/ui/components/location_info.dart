import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mini4wd_store/ui/style/colors.dart';

class LocationInfo extends StatelessWidget {
  const LocationInfo({
    super.key,
    required this.pos,
    required this.msg,
  });

  final Position? pos;
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.dividerLight, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentBlack.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.my_location,
            color: AppColors.primaryBlue,
            size: 36,
          ),
          const SizedBox(height: 10),
          Text(
            "Your Current Location",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Latitude: ${pos!.latitude.toStringAsFixed(5)}\nLongitude: ${pos!.longitude.toStringAsFixed(5)}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.accentYellow.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              msg.isEmpty ? "Location active" : msg,
              style: TextStyle(
                color: AppColors.accentYellow,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}