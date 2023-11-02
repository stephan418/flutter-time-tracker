import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:time_tracker/app/widgets/shell_scaffold_with_navbar.dart';

part 'routes.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Global go_router configuration
final goRouterConfig = GoRouter(
  routes: $appRoutes,
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/tasks',
);

@immutable
class TimerRoute extends GoRouteData {
  const TimerRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const Placeholder();
}

@immutable
class TasksRoute extends GoRouteData {
  const TasksRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const Placeholder();
}

@immutable
class StatsRoute extends GoRouteData {
  const StatsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const Placeholder();
}

/// Typed route configuration
///
/// The entire route tree is wrapped in a StatefulShellRoute which in turn wraps
/// a scaffold with a BottomNavigationBar around the entire application.
@TypedStatefulShellRoute<NavbarStatefulShellRoute>(
  branches: [
    TypedStatefulShellBranch(
      routes: [TypedGoRoute<TimerRoute>(path: '/timer')],
    ),
    TypedStatefulShellBranch(
      routes: [TypedGoRoute<TasksRoute>(path: '/tasks')],
    ),
    TypedStatefulShellBranch(
      routes: [TypedGoRoute<StatsRoute>(path: '/stats')],
    ),
  ],
)
class NavbarStatefulShellRoute extends StatefulShellRouteData {
  const NavbarStatefulShellRoute();

  static final $navigatorKey = _shellNavigatorKey;

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return ShellScaffoldWithNavbar(child: navigationShell);
  }
}
