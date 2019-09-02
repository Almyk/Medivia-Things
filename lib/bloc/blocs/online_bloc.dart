import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:medivia_things/bloc/state/online_state.dart';
import 'package:medivia_things/bloc/event/online_event.dart';
import 'dart:async';

import 'package:medivia_things/repository/repository.dart';

class OnlineBloc extends Bloc<OnlineEvent, OnlineState> {
  final Repository repository;
  OnlineBloc({@required this.repository});

  @override
  OnlineState get initialState => ShowOnlinePlayers();

  @override
  Stream<OnlineState> mapEventToState(OnlineEvent event) async* {
    if (event is OnlineUpdate) {
      yield UpdatePlayerCounter();
      yield ShowOnlinePlayers();
    }
    if (event is SortOnline) {
      repository.sortMode = (repository.sortMode + 1) % 3;
      print("sortMode: ${repository.sortMode}");
      await repository.sharedPreferences
          .setInt("sortMode", repository.sortMode);
      repository.sortOnline();
    }
  }
}
