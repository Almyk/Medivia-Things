import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class VipEvent extends Equatable {}

class AddNewVip extends VipEvent {
  final String name;

  AddNewVip({@required this.name});

  @override
  toString() => "AddNewVip";
}

class UpdateVipList extends VipEvent {
  @override
  toString() => "UpdateVipList";
}