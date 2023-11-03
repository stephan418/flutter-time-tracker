import 'package:flutter/material.dart';
import 'package:time_tracker/global/utils/tick_formatter.dart';

class TimeDisplay extends StatelessWidget {
  const TimeDisplay({required this.elapsed, super.key});

  final int elapsed;

  @override
  Widget build(BuildContext context) {
    final displayedTime = TickFormatter.format(elapsed);
    final displayLargeTheme = Theme.of(context)
        .textTheme
        .displayLarge!
        .copyWith(fontWeight: FontWeight.w600);

    return Text(
      displayedTime,
      style: displayLargeTheme,
    );
  }
}
