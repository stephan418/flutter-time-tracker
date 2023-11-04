import 'package:flutter/material.dart';
import 'package:local_timer_api/local_timer_api.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile({
    required this.task,
    this.onDismissed,
    this.onTap,
    super.key,
  });

  final Task task;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key('taskListTile_dismissible_${task.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.only(right: 16),
        alignment: Alignment.centerRight,
        color: theme.colorScheme.error,
        child: const Icon(Icons.delete),
      ),
      onDismissed: onDismissed,
      child: ListTile(
        leading: const Icon(Icons.task),
        title: Text(
          task.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          task.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: onTap == null ? null : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
