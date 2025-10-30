import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key, required this.title, required this.icon, required this.onTap});

  final String title;
  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      splashColor: Colors.grey[200],
      leading: Icon(icon), 
      title: Text(title)
    );
  }
}
