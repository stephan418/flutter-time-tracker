import 'package:flutter/material.dart';

const _navigationDestinations = [
  NavigationDestination(
    icon: Icon(Icons.timer_outlined),
    selectedIcon: Icon(Icons.timer),
    label: 'Timer',
  ),
  NavigationDestination(
    icon: Icon(Icons.task_outlined),
    selectedIcon: Icon(Icons.task),
    label: 'Tasks',
  ),
  NavigationDestination(
    icon: Icon(Icons.view_timeline_outlined),
    selectedIcon: Icon(Icons.view_timeline),
    label: 'Stats',
  ),
];

/// Represents a destination reachable through the app's BottomNavigationBar
enum NavbarDestination { timer, tasks, stats }

typedef DestinationClicked = void Function(NavbarDestination);

class Navbar extends StatelessWidget {
  const Navbar({super.key, this.onDestinationClicked, this.selectedIndex});

  final DestinationClicked? onDestinationClicked;
  final int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: _navigationDestinations,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      onDestinationSelected: _dispatchDestinationClickedByIndex,
      selectedIndex: selectedIndex ?? 0,
    );
  }

  void _dispatchDestinationClickedByIndex(int index) {
    final destination = switch (index) {
      0 => NavbarDestination.timer,
      1 => NavbarDestination.tasks,
      2 => NavbarDestination.stats,
      _ => throw DestinationNotFoundException(),
    };

    onDestinationClicked?.call(destination);
  }
}

class DestinationNotFoundException implements Exception {}
