import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class OnlineEvent extends Equatable {}

class OnlineUpdate extends OnlineEvent {
  final String server;

  OnlineUpdate({@required this.server});

  @override
  toString() => "Online Count Updated $server";
}

class SortOnline extends OnlineEvent {
  @override
  toString() => "SortOnlineEvent";
}
