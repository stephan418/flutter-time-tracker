import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker/ticker/ticker.dart';

part 'ticker_event.dart';
part 'ticker_state.dart';

class TickerBloc extends Bloc<TickerEvent, TickerState> {
  TickerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const TickerInitial()) {
    on<TickerStarted>(_onStarted);
    on<TickerReset>(_onReset);
    on<_TickerTicked>(_onTicked);
  }
  final Ticker _ticker;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TickerStarted event, Emitter<TickerState> emit) {
    emit(const TickerRunning(0));

    _tickerSubscription?.cancel();
    _tickerSubscription =
        _ticker.tick().listen((elapsed) => add(_TickerTicked(elapsed)));
  }

  void _onReset(TickerReset event, Emitter<TickerState> emit) {
    _tickerSubscription?.cancel();
    emit(const TickerInitial());
  }

  void _onTicked(_TickerTicked event, Emitter<TickerState> emit) {
    emit(TickerRunning(event.elapsed));
  }
}
