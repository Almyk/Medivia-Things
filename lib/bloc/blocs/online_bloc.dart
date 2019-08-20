import 'package:bloc/bloc.dart';
import 'package:medivia_things/bloc/event/online_state.dart';
import 'package:medivia_things/bloc/state/online_event.dart';
import 'dart:async';

class OnlineBloc extends Bloc<OnlineEvent, OnlineState> {
  @override
  OnlineState get initialState => ShowOnlinePlayers();

  @override
  Stream<OnlineState> mapEventToState(OnlineEvent event) async* {
    if (event is OnlineCountUpdate) {
      yield UpdatePlayerCounter();
      yield ShowOnlinePlayers();
    }
  }
}