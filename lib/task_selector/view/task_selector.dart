import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/task_selector/bloc/task_selector_bloc.dart';
import 'package:timer_repository/timer_repository.dart';

class TaskSelector extends StatelessWidget {
  const TaskSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskSelectorBloc>(
      create: (context) =>
          TaskSelectorBloc(taskRepository: context.read<TaskRepository>())
            ..add(const TaskSelectorSubscriptionRequested()),
      child: const TaskSelectorView(),
    );
  }
}

class TaskSelectorView extends StatelessWidget {
  const TaskSelectorView({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.select((TaskSelectorBloc bloc) => bloc.state.tasks);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: ListView(
        children: [
          const _UnselectListTile(),
          for (final task in tasks)
            ListTile(
              title: Text(task.title),
              leading: const Icon(Icons.check_circle_outline_outlined),
              onTap: () => Navigator.pop(context, task.id),
            ),
        ],
      ),
    );
  }
}

class _UnselectListTile extends StatelessWidget {
  const _UnselectListTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Unselect current task'),
      leading: const Icon(Icons.cancel_outlined),
      onTap: () => Navigator.pop(context, "clear"),
    );
  }
}
