import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bloc/blocs/navigation_bloc.dart';
import 'bloc/state/navigation_event.dart';

class VipListPage extends StatelessWidget {
  VipListPage({Key key, this.title, this.navigationBloc}) : super(key: key);

  final String title;
  final NavigationBloc navigationBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: Center(child: Text("Vip List Page"),),
      drawer: _myDrawer(),
    );
  }

  Widget _myDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Go to Online List"),
            onTap: () => navigationBloc.dispatch(ShowOnlineDestiny()),
          )
        ],
      ),
    );
  }
}