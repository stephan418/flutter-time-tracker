import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:time_tracker/app/routes/routes.dart';
import 'package:time_tracker/app/widgets/navbar.dart';

/// Scaffold wrapped around any route
///
/// Displays the app's BottomNavigationBar
class ShellScaffoldWithNavbar extends StatelessWidget {
  const ShellScaffoldWithNavbar({required this.child, super.key});

  final StatefulNavigationShell child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Navbar(
        selectedIndex: child.currentIndex,
        onDestinationClicked: (d) => _navigateToDestination(context, d),
      ),
      body: child,
    );
  }

  void _navigateToDestination(
    BuildContext context,
    NavbarDestination destination,
  ) {
    switch (destination) {
      case NavbarDestination.timer:
        return const TimerRoute().go(context);
      case NavbarDestination.tasks:
        return const TasksRoute().go(context);
      case NavbarDestination.stats:
        return const StatsRoute().go(context);
    }
  }
}
