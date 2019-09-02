import 'package:equatable/equatable.dart';

abstract class VipState extends Equatable {}

class UpdatingVipList extends VipState {
  @override
  toString() => "UpdatingVipList";
}

class ShowingVipList extends VipState {
  @override
  toString() => "ShowingVipList";
}
