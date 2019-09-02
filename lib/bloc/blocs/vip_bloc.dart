import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medivia_things/bloc/event/vip_event.dart';
import 'package:medivia_things/bloc/state/vip_state.dart';
import 'package:medivia_things/repository/repository.dart';

class VipBloc extends Bloc<VipEvent, VipState> {
  final Repository repository;

  VipBloc({@required this.repository}) : super();

  @override
  VipState get initialState => ShowingVipList();

  @override
  Stream<VipState> mapEventToState(VipEvent event) async* {
    if (event is AddNewVip) {
      yield UpdatingVipList();
      repository.addVipByName(event.name);
    }
    if (event is DeleteVip) {
      yield UpdatingVipList();
      repository.deleteVipByName(event.name);
    }
    if (event is UpdateVipListSuccess) {
      yield ShowingVipList();
    }
    if (event is UpdateVipListError) {
      yield ShowingVipList();
    }
    if (event is RefreshVipList) {
      yield UpdatingVipList();
      yield ShowingVipList();
    }
  }
}
