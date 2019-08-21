import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:medivia_things/utils/constants.dart';

abstract class NavigationState extends Equatable {
}

class VipList extends NavigationState {
  @override
  String toString() => "State: Show Vip List Page";
}

abstract class OnlineList extends NavigationState {
  final int server;
  OnlineList({@required this.server});
}

class OnlineListDestiny extends OnlineList {
  final int server = destiny;

  @override
  String toString() => "State: Show Online List for ${serverNames[server]}";
}

class OnlineListLegacy extends OnlineList {
  final int server = legacy;

  @override
  String toString() => "State: Show Online List for ${serverNames[server]}";
}

class OnlineListPendulum extends OnlineList {
  final int server = pendulum;

  @override
  String toString() => "State: Show Online List for ${serverNames[server]}";
}

class OnlineListProphecy extends OnlineList {
  final int server = prophecy;

  @override
  String toString() => "State: Show Online List for ${serverNames[server]}";
}

class OnlineListStrife extends OnlineList {
  final int server = strife;

  @override
  String toString() => "State: Show Online List for ${serverNames[server]}";
}