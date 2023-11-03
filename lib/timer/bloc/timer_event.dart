part of 'timer_bloc.dart';

@immutable
sealed class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object?> get props => [];
}

final class TimerSubscriptionRequested extends TimerEvent {
  const TimerSubscriptionRequested();
}

final class TimerStarted extends TimerEvent {
  const TimerStarted();
}

final class TimerTicked extends TimerEvent {
  const TimerTicked({required this.elapsed});

  final int elapsed;

  @override
  List<Object?> get props => [elapsed];
}

final class TimerStopped extends TimerEvent {
  const TimerStopped();
}

final class TimerReset extends TimerEvent {
  const TimerReset();
}

final class _TimerSaveRequested extends TimerEvent {
  const _TimerSaveRequested();
}
