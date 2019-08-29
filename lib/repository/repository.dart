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
import 'package:medivia_things/utils/notifications.dart';

class Repository {
  OnlineBloc onlineBloc;
  NavigationBloc navigationBloc;
  VipBloc vipBloc;

  final PlayerProvider playerProvider = PlayerProvider();

  final List<Map<String, dynamic>> onlineLists = new List(5);
  List<int> onlineCounts = [0, 0, 0, 0, 0];
  int sortMode = 0;
  List<Player> vipList = [];
  Timer onlineUpdateTimer;

  final Notifications notifications = Notifications();

  void init() {
    initVipList();
    getOnlineLists();
    onlineUpdateTimer =
        Timer.periodic(Duration(seconds: 30), (Timer t) => getOnlineLists());
    print("Started online list updater");
  }

  Future initVipList() async {
    print("initVipList");
    await playerProvider.initDB();
    Future.delayed(Duration(milliseconds: 500), () async {
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
      Map<String, dynamic> onlineList = json.decode(response.body);
      onlineLists[i] = onlineList;
      onlineCounts[i] = onlineList['players'].length;
    }
    sortOnline(sortMode);
    for (int i = 0; i < 5; i++) {
      onlineBloc.dispatch(OnlineUpdate(server: serverNames[i]));
    }
    await updateVipList();
  }

  Future vipUpdate() async {
    for (int i = 0; i < 5; i++) {
      List<String> names = [];
      vipList.forEach((player) async {
        bool online = false;
        for (final onlinePlayer in onlineLists[i]['players']) {
          if (player.name == onlinePlayer['name']) {
            if (player.status == "Offline") {
              names.add(player.name);
            }
            print("${player.name} is online");
            online = true;
            player.name = onlinePlayer['name'];
            player.level = onlinePlayer['level'].toString();
            player.lastLogin = onlinePlayer['login'];
            player.profession = onlinePlayer['vocation'];
            player.status = "Online";
            vipBloc.dispatch(RefreshVipList());
            await playerProvider.insertNewVip(player);
          }
        }
        notifications.playerLoggedIn(i, names.join(", "));
        if (player.world.toLowerCase() == serverNames[i] && !online) {
          player.status = "Offline";
          vipBloc.dispatch(RefreshVipList());
          await playerProvider.insertNewVip(player);
        }
      });
    }
    vipList = await playerProvider.getAllVip();
    vipBloc.dispatch(UpdateVipListSuccess());
  }

  Future updateVipList() async {
    vipList.forEach((player) async {
      bool online = false;
      for (int i = 0; i < 5; i++) {
        onlineLists[i]['players'].forEach((onlinePlayer) async {
          if (player.name == onlinePlayer['name']) {
            if (player.status == "Offline") {
              // TODO: create notification
              notifications.playerLoggedIn(i, player.name);
            }
            print("${player.name} is online");
            online = true;
            player.name = onlinePlayer['name'];
            player.level = onlinePlayer['level'].toString();
            player.lastLogin = onlinePlayer['login'];
            player.profession = onlinePlayer['vocation'];
            player.status = "Online";
            vipBloc.dispatch(RefreshVipList());
            await playerProvider.insertNewVip(player);
          }
        });
        if (online) break;
      }
      if (online == false && player.status != "Offline") {
        player.status = "Offline";
        vipBloc.dispatch(RefreshVipList());
        await playerProvider.insertNewVip(player);
      }
    });
    vipList = await playerProvider.getAllVip();
    vipBloc.dispatch(UpdateVipListSuccess());
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

  Future addVipByName(String name) async {
    Player player = await getPlayerInfo(name);
    if (player != null) {
      await playerProvider.insertNewVip(player);
      vipList = await playerProvider.getAllVip();
      vipBloc.dispatch(UpdateVipListSuccess());
    } else {
      vipBloc.dispatch(UpdateVipListError());
    }
  }

  Future deleteVipByName(String name) async {
    await playerProvider.deleteVip(name);
    vipList = await playerProvider.getAllVip();
    vipBloc.dispatch(UpdateVipListSuccess());
  }

  void sortOnline(int mode) {
    switch (mode) {
      case 0:
        sortOnlineByLevel();
        break;
      case 1:
        sortOnlineByName();
        break;
      case 2:
        sortOnlineByLogin();
        break;
      default:
        break;
    }
  }

  void sortOnlineByLevel() {
    for (int i = 0; i < 5; i++) {
      onlineLists[i]['players']
          .sort((a, b) => (b['level'] as int).compareTo(a['level'] as int));
      onlineBloc.dispatch(OnlineUpdate(server: serverNames[i]));
    }
  }

  void sortOnlineByName() {
    for (int i = 0; i < 5; i++) {
      onlineLists[i]['players']
          .sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
      onlineBloc.dispatch(OnlineUpdate(server: serverNames[i]));
    }
  }

  void sortOnlineByLogin() {
    final List<String> time = ["second", "seconds", "minute", "minutes", "hour", "hours"];
    for (int i = 0; i < 5; i++) {
      onlineLists[i]['players'].sort((a, b) {
        var A = a['login'].split(" ");
        var B = b['login'].split(" ");
        int aInt = int.tryParse(A[0]);
        int bInt = int.tryParse(B[0]);

        if (time.indexOf(A[1]) > time.indexOf(B[1])) {
          return -1;
        } else if (time.indexOf(A[1]) < time.indexOf(B[1])) {
          return 1;
        }

        if (aInt >= bInt) {
          return -1;
        }
        return 1;
      });
      onlineBloc.dispatch(OnlineUpdate(server: serverNames[i]));
    }
  }
}
