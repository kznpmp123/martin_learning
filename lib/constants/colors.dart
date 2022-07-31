import 'package:flutter/material.dart';

class KColors {
  final Color primary;
  final Color secondary;
  final Color grey;
  final Color black;
  final Color white;

  const KColors({
    required this.primary,
    required this.secondary,
    required this.grey,
    required this.black,
    required this.white,
  });
}

KColors colorScheme1 = KColors(
  primary: const Color(0xFF2366C9),
  secondary: Colors.teal.shade300,
  grey: Colors.grey.shade300,
  black: const Color(0xFF1C1C1C),
  white: Colors.white,
);
