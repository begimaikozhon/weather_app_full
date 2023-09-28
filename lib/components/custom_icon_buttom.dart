import 'package:flutter/material.dart';
import 'package:weather_app_full/constants/app_colors.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        icon,
        color: AppColors.white,
        size: 52,
      ),
    );
  }
}
