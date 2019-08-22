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

class Repository {
  OnlineBloc onlineBloc;
  NavigationBloc navigationBloc;
  VipBloc vipBloc;

  final PlayerProvider playerProvider = PlayerProvider();

  final List<Map<String, dynamic>> onlineLists = new List(5);
  List<int> onlineCounts = [0, 0, 0, 0, 0];
  List<Player> vipList = [];
  Timer onlineUpdateTimer;

  void init() {
    initVipList();
    getOnlineLists();
    onlineUpdateTimer =
        Timer.periodic(Duration(seconds: 30), (Timer t) => getOnlineLists());
    print("Started online list updater");
  }

  Future initVipList() async {
    print("initVipList");
    playerProvider.initDB();
    Future.delayed(Duration(seconds: 2), () async {
      vipBloc.dispatch(RefreshVipList());
      vipList = await playerProvider.getAllVip();
      vipBloc.dispatch(UpdateVipListSuccess());
    });
  }

  void dispose() {
    onlineUpdateTimer?.cancel();
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
    if (player != null) {
      print("success");
      //vipList.add(player);
      await playerProvider.insertNewVip(player);
      vipList = await playerProvider.getAllVip();
      vipBloc.dispatch(UpdateVipListSuccess());
    } else {
      vipBloc.dispatch(UpdateVipListError());
    }
  }
}
