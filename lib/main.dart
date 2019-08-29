import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medivia_things/bloc/blocs/navigation_bloc.dart';
import 'package:medivia_things/bloc/blocs/online_bloc.dart';
import 'package:medivia_things/bloc/blocs/vip_bloc.dart';
import 'package:medivia_things/bloc/state/navigation_state.dart';
import 'package:medivia_things/repository/repository.dart';
import 'package:medivia_things/pages/vip_list_page.dart';
import 'package:medivia_things/utils/drawer.dart';

import 'pages/online_list_page.dart';

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
  final repository = Repository()..init();
  final MyDrawer drawer = MyDrawer(
    repository: repository,
  );
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<NavigationBloc>(
        builder: (BuildContext context) {
          final NavigationBloc navigationBloc = NavigationBloc();
          repository.navigationBloc = navigationBloc;
          return navigationBloc;
        },
      ),
      BlocProvider<OnlineBloc>(
        builder: (BuildContext context) {
          final OnlineBloc onlineBloc = OnlineBloc(repository: repository);
          repository.onlineBloc = onlineBloc;
          return onlineBloc;
        },
      ),
      BlocProvider<VipBloc>(
        builder: (BuildContext context) {
          final vipBloc = VipBloc(repository: repository);
          repository.vipBloc = vipBloc;
          return vipBloc;
        },
      ),
    ],
    child: MyApp(
      repository: repository,
      drawer: drawer,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final Repository repository;
  final MyDrawer drawer;

  MyApp({Key key, @required this.repository, this.drawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NavigationBloc navigationBloc =
        BlocProvider.of<NavigationBloc>(context);
    return MaterialApp(
      title: 'Medivia Things',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(elevation: 10.0),
      ),
      home: BlocBuilder<NavigationBloc, NavigationState>(
        bloc: navigationBloc,
        builder: (BuildContext context, NavigationState state) {
          if (state is OnlineList) {
            return OnlineListPage(
              title: "Medivia Things",
              server: state.server,
              navigationBloc: navigationBloc,
              repository: repository,
            );
          } else {
            return VipListPage(
              title: "Medivia Things",
              navigationBloc: navigationBloc,
              repository: repository,
            );
          }
        },
      ),
    );
  }
}
