import 'package:flutter/material.dart';

class ListMenu {
  final String title;
  final IconData icon;
  final Color iconColor;
  final bool isNew;
  final Function()? onTap;

  ListMenu({
    required this.title,
    required this.icon,
    required this.iconColor,
    this.isNew = false,
    this.onTap,
  });
}
