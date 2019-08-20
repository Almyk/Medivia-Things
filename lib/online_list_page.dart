import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medivia_things/bloc/blocs/online_bloc.dart';
import 'package:medivia_things/bloc/event/online_state.dart';
import 'package:medivia_things/repository/repository.dart';
import 'package:medivia_things/utils/constants.dart';

import 'bloc/blocs/navigation_bloc.dart';

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
        );
      },
    );
  }
}

//class _OnlineListPageState extends State<OnlineListPage> {
//
//
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Column(
//          children: <Widget>[
//            Container(
//              child: Text(widget.title),
//              padding: EdgeInsets.symmetric(vertical: 4.0),
//            ),
//            Text(
//              serverNames[widget.server] + ' (${_onlineCounts[widget.server].toString()})',
//              style: TextStyle(
//                  fontSize: 16.0,
//                  fontWeight: FontWeight.bold,
//                  color: Colors.black),
//            ),
//          ],
//        ),
//      ),
//      body: _buildBody(context),
//      drawer: _createDrawer(),
//    );
//  }
//
//  Widget _buildBody(BuildContext context) {
//    return Container(child: _buildOnline(context));
//  }
//
//  Widget _buildOnline(BuildContext context) {
//    return StreamBuilder<List<Map<String, dynamic>>>(
//      stream: getOnlineLists(),
//      builder: (context, snapshot) {
//        if (!snapshot.hasData) return LinearProgressIndicator();
//        return _buildOnlineList(context, snapshot.data);
//      },
//    );
//  }
//
//  Widget _buildOnlineList(
//      BuildContext context, List<Map<String, dynamic>> snapshot) {
//    bool dataChanged = false;
//    for (var i = 0; i < 5; i++) {
//      int temp = snapshot[i]['players'].length;
//      if (temp != _onlineCounts[i]) {
//        _onlineCounts[i] = temp;
//        dataChanged = true;
//      }
//    }
//
//    if (dataChanged) {
//      SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {}));
//    }
//
//    return ListView(
//      padding: const EdgeInsets.only(top: 5.0),
//      children: _buildOnlineListItems(context, snapshot[widget.server]),
//    );
//  }
//
//  List<Widget> _buildOnlineListItems(
//      BuildContext context, Map<String, dynamic> data) {
//    List<dynamic> players = data['players'];
//    List<Widget> onlineList = new List<Widget>();
//
//    for (final player in players) {
//      onlineList.add(
//          _buildOnlineListItem(context, Map<String, dynamic>.from(player)));
//    }
//    return onlineList;
//  }
//
//  Widget _buildOnlineListItem(BuildContext context, Map<String, dynamic> data) {
//    final record = Record.fromMap(data);
//
//    return Padding(
//      key: ValueKey(record.name),
//      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
//      child: Container(
//        decoration: BoxDecoration(
//            border: Border.all(color: Colors.grey),
//            borderRadius: BorderRadius.circular(5.0)),
//        child: ListTile(
//          title: Text(record.name),
//          trailing: Text(record.login),
//          subtitle:
//          Text("Lv: " + record.level.toString() + ", " + record.vocation),
//          onTap: () {
//            print(record.toString());
//          },
//        ),
//      ),
//    );
//  }
//
//  Widget _createDrawer() {
//    final NavigationBloc navigationBloc = BlocProvider.of<NavigationBloc>(context);
//    return Drawer(
//      child: ListView(
//        // Important: Remove any padding from the ListView.
//        padding: EdgeInsets.zero,
//        children: <Widget>[
//          Container(
//            height: 80.0,
//            child: DrawerHeader(
//              child: Text('Medivia Things',
//                style: TextStyle(fontSize: 18.0),),
//              decoration: BoxDecoration(
//                color: Colors.blue,
//              ),
//            ),
//          ),
//          ListTile(
//            title: Text("Vip List"),
//            onTap: () => navigationBloc.dispatch(ShowVipList()),
//          ),
//          Center(
//              child: Text(
//                'ONLINE',
//                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, fontFamily: "Times"),
//              )),
//          Container(
//            decoration: BoxDecoration(
//                border: Border(
//                    top: BorderSide(color: Colors.grey),
//                    bottom: BorderSide(color: Colors.grey))),
//            child: Column(
//              children: <Widget>[
//                ListTile(
//                  contentPadding: EdgeInsets.only(left: 24.0),
//                  title: Text('Destiny' + ' (${_onlineCounts[destiny]})',
//                    style: TextStyle(fontFamily: "Times", fontSize: 18.0),),
//                  onTap: () {
//                    navigationBloc.dispatch(ShowOnlineDestiny());
//                    Navigator.pop(context);
//                  },
//                ),
//                ListTile(
//                  contentPadding: EdgeInsets.only(left: 24.0),
//                  title: Text('Legacy' + ' (${_onlineCounts[legacy]})',
//                    style: TextStyle(fontFamily: "Times", fontSize: 18.0),),
//                  onTap: () {
//                    navigationBloc.dispatch(ShowOnlineLegacy());
//                    Navigator.pop(context);
//                  },
//                ),
//                ListTile(
//                  contentPadding: EdgeInsets.only(left: 24.0),
//                  title: Text('Pendulum' + ' (${_onlineCounts[pendulum]})',
//                    style: TextStyle(fontFamily: "Times", fontSize: 18.0),),
//                  onTap: () {
//                    navigationBloc.dispatch(ShowOnlinePendulum());
//                    Navigator.pop(context);
//                  },
//                ),
//                ListTile(
//                  contentPadding: EdgeInsets.only(left: 24.0),
//                  title: Text('Prophecy' + ' (${_onlineCounts[prophecy]})',
//                    style: TextStyle(fontFamily: "Times", fontSize: 18.0),),
//                  onTap: () {
//                    navigationBloc.dispatch(ShowOnlineProphecy());
//                    Navigator.pop(context);
//                  },
//                ),
//                ListTile(
//                  contentPadding: EdgeInsets.only(left: 24.0),
//                  title: Text(
//                    'Strife' + ' (${_onlineCounts[strife]})',
//                    style: TextStyle(fontFamily: "Times", fontSize: 18.0),),
//                  onTap: () {
//                    navigationBloc.dispatch(ShowOnlineStrife());
//                    Navigator.pop(context);
//                  },
//                ),
//              ],
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}