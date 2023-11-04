import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_timer_api/local_timer_api.dart';
import 'package:time_tracker/edit_task/bloc/edit_task_bloc.dart';
import 'package:time_tracker/global/global.dart';
import 'package:timer_repository/timer_repository.dart';

class EditTaskPage extends StatelessWidget {
  const EditTaskPage({this.taskToEdit, super.key});

  final Task? taskToEdit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditTaskBloc>(
      create: (context) => EditTaskBloc(
        taskToEdit: taskToEdit,
        taskRepository: context.read<TaskRepository>(),
      ),
      child: BlocListener<EditTaskBloc, EditTaskState>(
        listenWhen: (previous, next) =>
            previous.taskSaveStatus != next.taskSaveStatus &&
            next.taskSaveStatus == RequestStatus.success,
        listener: (context, state) => context.pop(),
        child: const EditTaskView(),
      ),
    );
  }
}

class EditTaskView extends StatelessWidget {
  const EditTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    final isCreating =
        context.select((EditTaskBloc bloc) => bloc.state.isCreating);
    final saveStatus =
        context.select((EditTaskBloc bloc) => bloc.state.taskSaveStatus);

    return Scaffold(
      appBar: AppBar(
        title: Text(isCreating ? 'New Task' : 'Edit Task'),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Save',
        onPressed: saveStatus.isLoadingOrSuccess
            ? null
            : () =>
                context.read<EditTaskBloc>().add(const EditTaskTaskSubmitted()),
        child: saveStatus.isLoadingOrSuccess
            ? const CircularProgressIndicator()
            : const Icon(Icons.check),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [_TitleField(), _DescriptionField()],
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditTaskBloc>().state;
    final hintText = state.taskToEdit?.title ?? '';

    return TextFormField(
      key: const Key('editTaskView_title_textFormField'),
      initialValue: state.title,
      decoration: InputDecoration(
        enabled: !state.taskSaveStatus.isLoadingOrSuccess,
        labelText: 'Title',
        hintText: hintText,
      ),
      maxLength: 40,
      inputFormatters: [LengthLimitingTextInputFormatter(40)],
      onChanged: (value) =>
          context.read<EditTaskBloc>().add(EditTaskTitleChanged(title: value)),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditTaskBloc>().state;
    final hintText = state.taskToEdit?.description ?? '';

    return TextFormField(
      key: const Key('editTaskView_description_textFormField'),
      initialValue: state.description,
      decoration: InputDecoration(
        enabled: !state.taskSaveStatus.isLoadingOrSuccess,
        labelText: 'Description',
        hintText: hintText,
      ),
      maxLength: 200,
      maxLines: 2,
      inputFormatters: [
        LengthLimitingTextInputFormatter(200),
      ],
      onChanged: (value) => context
          .read<EditTaskBloc>()
          .add(EditTaskDescriptionChanged(description: value)),
    );
  }
}
