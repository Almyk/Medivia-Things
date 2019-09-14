import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medivia_things/bloc/blocs/navigation_bloc.dart';
import 'package:medivia_things/bloc/event/navigation_event.dart';
import 'package:medivia_things/repository/repository.dart';

import 'constants.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({Key key, @required this.repository}) : super(key: key);
  final Repository repository;

  @override
  Widget build(BuildContext context) {
    final NavigationBloc navigationBloc =
        BlocProvider.of<NavigationBloc>(context);
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 80.0,
            child: DrawerHeader(
              child: Text(
                'ViP List for Medivia',
                style: TextStyle(fontSize: 18.0),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.star,
              color: Colors.yellow[800],
            ),
            title: Text(
              'Vip List',
              style: TextStyle(fontFamily: "Times", fontSize: 18.0),
            ),
            onTap: () {
              navigationBloc.dispatch(ShowVipList());
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.hotel,
            ),
            title: Text(
              'Bedmages',
              style: TextStyle(fontFamily: "Times", fontSize: 18.0),
            ),
            onTap: () {
              navigationBloc.dispatch(ShowBedmageList());
              Navigator.pop(context);
            },
          ),
          Center(
              child: Text(
            'ONLINE',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                fontFamily: "Times"),
          )),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.grey),
                    bottom: BorderSide(color: Colors.grey))),
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.only(left: 24.0),
                  title: Text(
                    'Destiny' + ' (${repository.onlineCounts[destiny]})',
                    style: TextStyle(fontFamily: "Times", fontSize: 18.0),
                  ),
                  onTap: () {
                    navigationBloc.dispatch(ShowOnlineDestiny());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 24.0),
                  title: Text(
                    'Legacy' + ' (${repository.onlineCounts[legacy]})',
                    style: TextStyle(fontFamily: "Times", fontSize: 18.0),
                  ),
                  onTap: () {
                    navigationBloc.dispatch(ShowOnlineLegacy());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 24.0),
                  title: Text(
                    'Pendulum' + ' (${repository.onlineCounts[pendulum]})',
                    style: TextStyle(fontFamily: "Times", fontSize: 18.0),
                  ),
                  onTap: () {
                    navigationBloc.dispatch(ShowOnlinePendulum());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 24.0),
                  title: Text(
                    'Prophecy' + ' (${repository.onlineCounts[prophecy]})',
                    style: TextStyle(fontFamily: "Times", fontSize: 18.0),
                  ),
                  onTap: () {
                    navigationBloc.dispatch(ShowOnlineProphecy());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 24.0),
                  title: Text(
                    'Strife' + ' (${repository.onlineCounts[strife]})',
                    style: TextStyle(fontFamily: "Times", fontSize: 18.0),
                  ),
                  onTap: () {
                    navigationBloc.dispatch(ShowOnlineStrife());
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
