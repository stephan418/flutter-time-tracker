part of 'ticker_bloc.dart';

sealed class TickerState extends Equatable {
  const TickerState(this.elapsed);

  final int elapsed;

  @override
  List<Object> get props => [elapsed];
}

final class TickerInitial extends TickerState {
  const TickerInitial() : super(0);
}

final class TickerRunning extends TickerState {
  const TickerRunning(super.elapsed);
}
