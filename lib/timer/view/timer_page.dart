import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:time_tracker/task_selector/view/task_selector.dart';
import 'package:time_tracker/ticker/bloc/ticker_bloc.dart';
import 'package:time_tracker/timer/bloc/timer_bloc.dart';
import 'package:time_tracker/timer/time_display.dart';
import 'package:timer_repository/timer_repository.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerBloc(
        taskRepository: context.read<TaskRepository>(),
        sessionRepository: context.read<SessionRepository>(),
        preferencesRepository: context.read<PreferencesRepository>(),
      )..add(const TimerSubscriptionRequested()),
      child: const TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TickerBloc, TickerState>(
      listener: (context, state) {
        final tickerBloc = context.read<TimerBloc>();
        if (tickerBloc.state.status == TimerStatus.running) {
          tickerBloc.add(TimerTicked(elapsed: state.elapsed));
        }
      },
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _TimeAndTaskDisplay(),
          _PlayPauseFab(),
          _ChangeProjectSheetButton(),
        ],
      ),
    );
  }
}

class _TimeAndTaskDisplay extends StatelessWidget {
  const _TimeAndTaskDisplay();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocSelector<TimerBloc, TimerState, String?>(
      selector: (state) => state.task?.title,
      builder: (context, title) {
        return Column(
          children: [
            BlocSelector<TimerBloc, TimerState, int>(
              selector: (state) => state.totalDuration,
              builder: (context, ticks) => TimeDisplay(elapsed: ticks),
            ),
            ...(title != null
                ? [
                    Text(
                      'spent on',
                      style: textTheme.bodyLarge,
                    ),
                    Text(title, style: textTheme.displaySmall),
                  ]
                : [
                    Text(
                      'all time spent on any task',
                      style: textTheme.headlineMedium,
                    ),
                  ]),
          ],
        );
      },
    );
  }
}

class _PlayPauseFab extends StatelessWidget {
  const _PlayPauseFab();

  @override
  Widget build(BuildContext context) {
    const heroTag = 'timerView_playPause_floatingActionButton';
    final status = context.select((TimerBloc bloc) => bloc.state.status);

    if (status == TimerStatus.initial || status == TimerStatus.ready) {
      return FloatingActionButton(
        onPressed: () => _onStartPressed(context),
        heroTag: heroTag,
        child: const Icon(Icons.play_arrow),
      );
    } else {
      return FloatingActionButton(
        onPressed: () => _onStopPressed(context),
        heroTag: heroTag,
        child: const Icon(Icons.stop),
      );
    }
  }

  void _onStartPressed(BuildContext context) {
    context.read<TimerBloc>().add(const TimerStarted());
    context.read<TickerBloc>().add(const TickerStarted());
  }

  void _onStopPressed(BuildContext context) {
    context.read<TickerBloc>().add(const TickerReset());
    context.read<TimerBloc>().add(const TimerStopped());
  }
}

class _ChangeProjectSheetButton extends StatelessWidget {
  const _ChangeProjectSheetButton();

  @override
  Widget build(BuildContext context) {
    final status = context.select((TimerBloc bloc) => bloc.state.status);
    final bloc = context.read<TimerBloc>();

    return ElevatedButton(
      onPressed: status != TimerStatus.running
          ? () async {
              final v = await showModalBottomSheet<String>(
                context: context,
                builder: (context) => const SizedBox(
                  height: 300,
                  child: TaskSelector(),
                ),
              );

              if (v != null) {
                if (v == 'clear') {
                  bloc.add(const TimerTaskSelected(taskId: null));
                } else {
                  bloc.add(TimerTaskSelected(taskId: v));
                }
              }
            }
          : null,
      child: const Text(
        'Change active task',
      ),
    );
  }
}
