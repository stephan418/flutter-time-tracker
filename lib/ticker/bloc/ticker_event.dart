part of 'ticker_bloc.dart';

@immutable
sealed class TickerEvent extends Equatable {
  const TickerEvent();

  @override
  List<Object?> get props => [];
}

final class TickerStarted extends TickerEvent {
  const TickerStarted();
}

final class TickerReset extends TickerEvent {
  const TickerReset();
}

final class _TickerTicked extends TickerEvent {
  const _TickerTicked(this.elapsed);

  final int elapsed;
}
