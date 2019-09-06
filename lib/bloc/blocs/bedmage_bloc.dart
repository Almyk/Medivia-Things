import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:medivia_things/bloc/event/bedmage_event.dart';
import 'package:medivia_things/bloc/state/bedmage_state.dart';
import 'package:medivia_things/models/bedmage.dart';
import 'package:medivia_things/repository/repository.dart';

class BedmageBloc extends Bloc<BedmageEvent, BedmageState> {
  BedmageBloc({@required this.repository});

  final Repository repository;

  @override
  get initialState => ShowBedmages(props: []);

  @override
  Stream<BedmageState> mapEventToState(BedmageEvent event) async* {
    if (event is BedmagesUpdated) {
      yield UpdatingBedmages();
      yield ShowBedmages(props: repository.bedmageList);
    }
    if (event is AddBedmage) {
      final bedmage = Bedmage(name: event.name, interval: event.interval);
      repository.bedmageList.add(bedmage);
      yield UpdatingBedmages();
      yield ShowBedmages(props: repository.bedmageList);
    }
  }
}
