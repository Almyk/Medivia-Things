import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medivia_things/bloc/blocs/online_bloc.dart';
import 'package:medivia_things/bloc/event/online_state.dart';
import 'package:medivia_things/repository/repository.dart';
import 'package:medivia_things/utils/constants.dart';
import 'package:medivia_things/utils/drawer.dart';
import 'package:medivia_things/utils/utilities.dart';

import '../bloc/blocs/navigation_bloc.dart';

class OnlineListPage extends StatelessWidget {
  OnlineListPage(
      {Key key, this.title, this.server, this.navigationBloc, this.repository}
      ) : super(key: key);

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
          drawer: MyDrawer(repository: repository,),
          appBar: AppBar(
            title: Column(
              children: <Widget>[
                Container(
                  child: Text(title),
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                ),
                Text(
                  serverNames[server] + ' (${repository.onlineCounts[server].toString()})',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          body: _buildOnlineListItems(context, repository.onlineLists[server])
        );
      },
    );
  }

  Widget _buildOnlineListItems(
      BuildContext context, Map<String, dynamic> data) {
    List<dynamic> players = data['players'];
    List<Widget> onlineList = new List<Widget>();

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
    final record = Record.fromMap(data);

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
}