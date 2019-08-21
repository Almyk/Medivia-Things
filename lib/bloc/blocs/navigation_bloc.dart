import 'package:bloc/bloc.dart';
import 'package:medivia_things/bloc/state/navigation_state.dart';
import 'package:medivia_things/bloc/event/navigation_event.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  @override
  NavigationState get initialState => VipList();

  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) async*{
    if (event is ShowVipList) {
      yield VipList();
    }
    if (event is ShowOnlineDestiny) {
      yield OnlineListDestiny();
    }
    if (event is ShowOnlineLegacy) {
      yield OnlineListLegacy();
    }
    if (event is ShowOnlinePendulum) {
      yield OnlineListPendulum();
    }
    if (event is ShowOnlineProphecy) {
      yield OnlineListProphecy();
    }
    if (event is ShowOnlineStrife) {
      yield OnlineListStrife();
    }
  }

}