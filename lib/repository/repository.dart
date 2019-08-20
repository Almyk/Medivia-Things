import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:medivia_things/bloc/blocs/online_bloc.dart';
import 'package:medivia_things/bloc/state/online_event.dart';
import 'package:medivia_things/utils/constants.dart';

class Repository {
  OnlineBloc onlineBloc;
  final List<Map<String, dynamic>> onlineLists = new List(5);
  List<int> onlineCounts = [0, 0, 0, 0, 0];

  Timer onlineUpdateTimer;

  void init() {
    getOnlineLists();
    onlineUpdateTimer = Timer.periodic(Duration(seconds: 30), (Timer t) => getOnlineLists());
    print("Started online list updater");
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
}
