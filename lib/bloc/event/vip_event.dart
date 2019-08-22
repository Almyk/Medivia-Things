import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class VipEvent extends Equatable {}

class AddNewVip extends VipEvent {
  final String name;

  AddNewVip({@required this.name});

  @override
  toString() => "AddNewVip $name";
}

class UpdateVipListSuccess extends VipEvent {
  @override
  toString() => "UpdateVipListSuccess";
}

class UpdateVipListError extends VipEvent {
  @override
  toString() => "UpdateVipListError";
}

class RefreshVipList extends VipEvent {
  @override
  toString() => "RefreshVipList";
}