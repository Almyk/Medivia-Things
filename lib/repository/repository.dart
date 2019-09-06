import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:medivia_things/bloc/blocs/navigation_bloc.dart';
import 'package:medivia_things/bloc/blocs/online_bloc.dart';
import 'package:medivia_things/bloc/blocs/vip_bloc.dart';
import 'package:medivia_things/bloc/event/online_event.dart';
import 'package:medivia_things/bloc/event/vip_event.dart';
import 'package:medivia_things/models/bedmage.dart';
import 'package:medivia_things/utils/constants.dart';
import 'package:medivia_things/models/player.dart';
import 'package:medivia_things/utils/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repository {
  OnlineBloc onlineBloc;
  NavigationBloc navigationBloc;
  VipBloc vipBloc;

  final PlayerProvider playerProvider = PlayerProvider();

  final List<Map<String, dynamic>> onlineLists = List(5);
  List<int> onlineCounts = [0, 0, 0, 0, 0];
  int sortMode = 0;

  List<Player> vipList = List();
  List<Bedmage> bedmageList = List();

  Timer onlineUpdateTimer;
  Timer bedmageUpdateTimer;

  final Notifications notifications = Notifications();
  SharedPreferences sharedPreferences;

  void init() {
    initPreferences();
    initVipList();
    getOnlineLists();
    initTimers();
    print("Started online list updater");
  }

  void initTimers() {
    onlineUpdateTimer =
        Timer.periodic(Duration(seconds: 30), (Timer t) => getOnlineLists());
    bedmageUpdateTimer =
        Timer.periodic(Duration(minutes: 1), (Timer t) => updateBedmages());
  }

  Future initPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sortMode = sharedPreferences.getInt("sortMode") ?? 0;
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
    sortOnline();
    for (int i = 0; i < 5; i++) {
      onlineBloc.dispatch(OnlineUpdate(server: serverNames[i]));
    }
    await updateVipList();
  }

  Future updateVipList() async {
    Map<int, List<String>> loginList = new Map<int, List<String>>();
    for (Player player in vipList) {
      bool online = false;
      var idx = serverNames.indexOf(player.world);

      for (final onlinePlayer in onlineLists[idx]['players']) {
        if (player.name == onlinePlayer['name']) {
          if (player.status == "Offline") {
            // add player name to notification list
            if (!loginList.containsKey(idx)) {
              loginList[idx] = List<String>();
            }
            loginList[idx].add(player.name);
          }
          print("${player.name} is online");
          online = true;
          player.name = onlinePlayer['name'];
          player.level = onlinePlayer['level'].toString();
          player.lastLogin = onlinePlayer['login'];
          player.profession = onlinePlayer['vocation'];
          player.status = "Online";
          // vipBloc.dispatch(RefreshVipList());
          await playerProvider.insertNewVip(player);
          break;
        }
      }
      if (online == false && player.status != "Offline") {
        player.status = "Offline";
        // vipBloc.dispatch(RefreshVipList());
        await playerProvider.insertNewVip(player);
      }
    }
    vipList = await playerProvider.getAllVip();

    for (final idx in loginList.keys) {
      notifications.playerLoggedIn(idx, loginList[idx].join(", "));
    }

    // vipBloc.dispatch(UpdateVipListSuccess());
    vipBloc.dispatch(RefreshVipList());
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

  void sortOnline() {
    switch (sortMode) {
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
    final List<String> time = [
      "second",
      "seconds",
      "minute",
      "minutes",
      "hour",
      "hours"
    ];
    for (int i = 0; i < 5; i++) {
      onlineLists[i]['players'].sort((a, b) {
        List<String> A = a['login'].split(" ");
        List<String> B = b['login'].split(" ");
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

  Future updateBedmages() async {
    for (final bedmage in bedmageList) {
      var response = await http.get(playerUrl + bedmage.name); // TODO make this call a method
      Map body = json.decode(response.body);
      bedmage.lastLogin = body['last login'];
      bedmage.calculateTimeLeft();
    }
    // TODO: dispatch event
  }
}
