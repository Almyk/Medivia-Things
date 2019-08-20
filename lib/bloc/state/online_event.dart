import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class OnlineEvent extends Equatable {}

class OnlineCountUpdate extends OnlineEvent {
  final String server;

  OnlineCountUpdate({@required this.server});

  @override
  toString() => "Online Count Updated $server";
}