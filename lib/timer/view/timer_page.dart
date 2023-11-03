import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/ticker/bloc/ticker_bloc.dart';
import 'package:time_tracker/timer/bloc/timer_bloc.dart';
import 'package:time_tracker/timer/time_display.dart';
import 'package:timer_repository/timer_repository.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TimerBloc(sessionRepository: context.read<SessionRepository>())
            ..add(const TimerSubscriptionRequested()),
      child: const TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<TickerBloc, TickerState>(
      listener: (context, state) {
        final tickerBloc = context.read<TimerBloc>();
        if (tickerBloc.state.status == TimerStatus.running) {
          tickerBloc.add(TimerTicked(elapsed: state.elapsed));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              BlocSelector<TimerBloc, TimerState, int>(
                selector: (state) => state.totalDuration,
                builder: (context, state) => TimeDisplay(elapsed: state),
              ),
              Text(
                'today in',
                style: textTheme.bodyLarge,
              ),
              Text('Some project', style: textTheme.displaySmall),
            ],
          ),
          BlocSelector<TimerBloc, TimerState, TimerStatus>(
            selector: (state) => state.status,
            builder: (context, state) =>
                state == TimerStatus.initial || state == TimerStatus.ready
                    ? FloatingActionButton(
                        onPressed: () => _onStartPressed(context),
                        child: const Icon(Icons.play_arrow),
                      )
                    : FloatingActionButton(
                        onPressed: () => _onStopPressed(context),
                        child: const Icon(Icons.stop),
                      ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text(
              'Change project',
            ),
          ),
        ],
      ),
    );
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
