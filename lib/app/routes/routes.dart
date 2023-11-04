import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_timer_api/local_timer_api.dart';
import 'package:time_tracker/app/widgets/shell_scaffold_with_navbar.dart';
import 'package:time_tracker/edit_task/view/edit_task_page.dart';
import 'package:time_tracker/stats/view/stats_page.dart';
import 'package:time_tracker/tasks/view/tasks_page.dart';
import 'package:time_tracker/timer/view/view.dart';

part 'routes.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Global go_router configuration
final goRouterConfig = GoRouter(
  routes: $appRoutes,
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/timer',
);

@immutable
class TimerRoute extends GoRouteData {
  const TimerRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const TimerPage();
}

@immutable
class TasksRoute extends GoRouteData {
  const TasksRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const TasksPage();
}

@immutable
class TaskEditRoute extends GoRouteData {
  const TaskEditRoute(this.$extra);

  final Task $extra;

  static final $parentNavigatorKey = _rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) => EditTaskPage(
        taskToEdit: $extra,
      );
}

class TaskAddRoute extends GoRouteData {
  const TaskAddRoute();

  static final $parentNavigatorKey = _rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const EditTaskPage();
}

@immutable
class StatsRoute extends GoRouteData {
  const StatsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const StatsPage();
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
      routes: [
        TypedGoRoute<TasksRoute>(
          path: '/tasks',
          routes: [
            TypedGoRoute<TaskEditRoute>(path: 'edit'),
            TypedGoRoute<TaskAddRoute>(path: 'new'),
          ],
        ),
      ],
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
