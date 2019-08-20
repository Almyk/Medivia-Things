import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:medivia_things/bloc/blocs/navigation_bloc.dart';
import 'package:medivia_things/bloc/event/navigation_state.dart';
import 'package:medivia_things/bloc/state/navigation_event.dart';
import 'package:medivia_things/repository/repository.dart';
import 'package:medivia_things/utils/constants.dart';
import 'package:medivia_things/vip_list_page.dart';

import 'online_list_page.dart';


class MyBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print("Event: $event");
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  BlocSupervisor.delegate = MyBlocDelegate();
  final repository = Repository();
  runApp(
    BlocProvider<NavigationBloc>(
      builder: (context) {
        return NavigationBloc();
      },
      child: MyApp(repository: repository),
    )
  );
}

class MyApp extends StatelessWidget {
  final Repository repository;
  
  MyApp({Key key, @required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NavigationBloc navigationBloc = BlocProvider.of<NavigationBloc>(context);
    return MaterialApp(
      title: 'Medivia Things',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocBuilder<NavigationBloc, NavigationState>(
        bloc: navigationBloc,
        builder: (BuildContext context, NavigationState state) {
          if (state is OnlineList) {
            return OnlineListPage(
                title: "Medivia Things",
                server: state.server,
            );
          }
          else {
            return VipListPage(title: "Medivia Things", navigationBloc: navigationBloc,);
          }
        },
      ),
    );
  }
}

class Record {
  final String name;
  final int level;
  final String vocation;
  final String login;

  Record.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        assert(map['level'] != null),
        assert(map['vocation'] != null),
        assert(map['login'] != null),
        name = map['name'],
        level = map['level'],
        vocation = map['vocation'],
        login = map['login'];

  @override
  String toString() => "Record<$name:$level:$vocation:$login>";
}
