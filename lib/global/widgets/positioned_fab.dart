import 'package:flutter/material.dart';

class PositionedFab extends StatelessWidget {
  const PositionedFab({required this.fab, super.key});

  final Widget fab;

  @override
  Widget build(BuildContext context) {
    return Positioned(bottom: 16, right: 16, child: fab);
  }
}
