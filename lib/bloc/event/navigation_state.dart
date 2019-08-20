import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:medivia_things/utils/constants.dart';

abstract class NavigationState extends Equatable {
}

class VipList extends NavigationState {
  @override
  String toString() => "State: Show Vip List Page";
}

class OnlineList extends NavigationState {
  final int server;

  OnlineList({@required this.server});

  @override
  String toString() => "State: Show Online List for ${serverNames[server]}";
}