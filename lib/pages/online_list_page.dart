import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medivia_things/bloc/blocs/online_bloc.dart';
import 'package:medivia_things/bloc/event/online_event.dart';
import 'package:medivia_things/bloc/state/online_state.dart';
import 'package:medivia_things/repository/repository.dart';
import 'package:medivia_things/utils/constants.dart';
import 'package:medivia_things/utils/drawer.dart';
import 'package:medivia_things/models/onlinePlayer.dart';

import '../bloc/blocs/navigation_bloc.dart';

class OnlineListPage extends StatelessWidget {
  OnlineListPage(
      {Key key, this.title, this.server, this.navigationBloc, this.repository})
      : super(key: key);

  final String title;
  final int server;
  final NavigationBloc navigationBloc;
  final Repository repository;

  @override
  Widget build(BuildContext context) {
    final OnlineBloc onlineBloc = BlocProvider.of<OnlineBloc>(context);
    return BlocBuilder<OnlineBloc, OnlineState>(
      bloc: onlineBloc,
      builder: (BuildContext context, OnlineState state) {
        return Scaffold(
            drawer: MyDrawer(
              repository: repository,
            ),
            appBar: AppBar(
              actions: <Widget>[
                Builder(
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Icon(Icons.sort),
                        onTap: () {
                          _showSortModeSnackBar(context);
                          onlineBloc.dispatch(SortOnline());
                        },
                      ),
                    );
                  },
                ),
              ],
              title: Text(
                serverNames[server] +
                    ' (${repository.onlineCounts[server].toString()})',
              ),
            ),
            body: SafeArea(
                child: _buildOnlineListItems(
                    context, repository.onlineLists[server])));
      },
    );
  }

  Widget _buildOnlineListItems(
      BuildContext context, Map<String, dynamic> data) {
    List<dynamic> players = data['players'];
    List<Widget> onlineList = new List<Widget>();

    if (players.length == 0) {
      return Center(
        child: Text(
          "farrk has tiny hands",
          style:
              TextStyle(fontSize: 24.0, color: Colors.black.withOpacity(0.2)),
        ),
      );
    }

    for (final player in players) {
      onlineList.add(
          _buildOnlineListItem(context, Map<String, dynamic>.from(player)));
    }
    return Scrollbar(
      child: ListView(
        children: onlineList,
      ),
    );
  }

  Widget _buildOnlineListItem(BuildContext context, Map<String, dynamic> data) {
    final record = OnlinePlayer.fromMap(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0)),
        child: ListTile(
          title: Text(record.name),
          trailing: Text(record.login),
          subtitle:
              Text("Lv: " + record.level.toString() + ", " + record.vocation),
          onTap: () {
            print(record.toString());
          },
        ),
      ),
    );
  }

  void _showSortModeSnackBar(BuildContext context) {
    final scaffold = Scaffold.of(context);
    String text;
    final mode = (repository.sortMode + 1) % 3;

    switch (mode) {
      case 0:
        text = "Sort online by level";
        break;
      case 1:
        text = "Sort online by name";
        break;
      case 2:
        text = "Sort online by online time";
        break;
      default:
        text = "Something went wrong";
    }

    scaffold.removeCurrentSnackBar();
    scaffold.showSnackBar(
      SnackBar(
        content: Align(
            alignment: Alignment.bottomCenter,
            heightFactor: 1.0,
            child: Text(text)),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
