import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:medivia_things/bloc/blocs/navigation_bloc.dart';
import 'package:medivia_things/bloc/blocs/online_bloc.dart';
import 'package:medivia_things/bloc/blocs/vip_bloc.dart';
import 'package:medivia_things/bloc/event/online_event.dart';
import 'package:medivia_things/bloc/event/vip_event.dart';
import 'package:medivia_things/utils/constants.dart';
import 'package:medivia_things/models/player.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class Repository {
  OnlineBloc onlineBloc;
  NavigationBloc navigationBloc;
  VipBloc vipBloc;

  Database database;

  final List<Map<String, dynamic>> onlineLists = new List(5);
  List<int> onlineCounts = [0, 0, 0, 0, 0];
  List<Player> vipList = [];
  Timer onlineUpdateTimer;

  void init() {
    loadDatabase();
    getOnlineLists();
    onlineUpdateTimer = Timer.periodic(Duration(seconds: 30), (Timer t) => getOnlineLists());
    print("Started online list updater");
  }

  void dispose() {
    onlineUpdateTimer?.cancel();
  }

  void loadDatabase() async {
    this.database = await openDatabase(
      path.join(await getDatabasesPath(), 'medivia_database.db')
    );
    // TODO: probably dispatch an event here to load vip list from DB
  }

  void getOnlineLists() async {
    for (int i = 0; i < 5; i++) {
      var response = await http.get(onlineUrl + serverNames[i].toLowerCase());
      Map onlineList = json.decode(response.body);
      onlineLists[i] = onlineList;
      onlineCounts[i] = onlineList['players'].length;
      onlineBloc.dispatch(OnlineCountUpdate(server: serverNames[i]));
    }
  }

  Future<Player> getPlayerInfo(String name) async {
    try {
      var response = await http.get(playerUrl + name.toLowerCase());
      Map body = json.decode(response.body);
      var player = Player.fromMap(body);
      print(player);
      return player;
    } catch (e) {
      print(e);
    }
    return null;
  }

  void addVipByName(String name) async {
    Player player = await getPlayerInfo(name);
    print("test");
    if (player.name != null) {
      print("success");
      vipList.add(player);
      vipBloc.dispatch(UpdateVipListSuccess());
    } else {
      vipBloc.dispatch(UpdateVipListError());
    }
  }
}
