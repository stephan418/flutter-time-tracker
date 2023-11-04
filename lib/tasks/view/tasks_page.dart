import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/app/routes/routes.dart';
import 'package:time_tracker/global/global.dart';
import 'package:time_tracker/global/widgets/positioned_fab.dart';
import 'package:time_tracker/tasks/bloc/tasks_bloc.dart';
import 'package:time_tracker/tasks/widgets/task_list_tile.dart';
import 'package:timer_repository/timer_repository.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TasksBloc>(
      create: (context) =>
          TasksBloc(taskRepository: context.read<TaskRepository>())
            ..add(const TasksSubscriptionRequested()),
      child: const TasksView(),
    );
  }
}

class TasksView extends StatelessWidget {
  const TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<TasksBloc, TasksState>(
          builder: (context, state) {
            if (state.tasksLoadStatus == RequestStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.tasksLoadStatus == RequestStatus.success) {
              if (state.tasks.isEmpty) {
                return const Center(
                  child: Text('There are no tasks. Create one now!'),
                );
              }
            }

            return ListView(
              children: [
                for (final task in state.tasks)
                  TaskListTile(
                    task: task,
                    onDismissed: (_) => context.read<TasksBloc>()
                      ..add(TasksTaskDeleted(id: task.id!)),
                    onTap: () => TaskEditRoute(task).go(context),
                  ),
              ],
            );
          },
        ),
        PositionedFab(
          fab: FloatingActionButton(
            key: const Key('tasksView_add_floatingActionButton'),
            onPressed: () => const TaskAddRoute().go(context),
            tooltip: 'Add task',
            heroTag: 'tasks_common_floatingActionButton',
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
